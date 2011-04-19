# encoding: UTF-8
require 'hpricot'
require 'uri'
require 'open-uri'

=begin

implemented bettypes:
  3Way
implemented sports:
  Soccer =>
    Deutschland => 1. BUndesliga, 2. Bundesliga
    England => Premier League
    Spanien => (Primera Division) Liga BBVA
    Italien => Serie A

=end

class TipicoScraper
  # constructor
  def initialize(sports={
      "Fußball" => {
        "Deutschland" => [ "1. Bundesliga", "2. Bundesliga" ],
        "England" => [ "Premier League" ],
        "Spanien" => [ "Liga BBVA" ],
        "Italien" => [ "Serie A"]
        }
		} )
		@sports = sports
    @bookie = Bookmaker.find_or_create_by_name("Tipico")
    @dir = File.dirname(__FILE__)
		@link_hash = {}
  end

  def load(url)
    page = open(URI.escape(url), "User-Agent" => "Mozilla/5.0 (Windows; U; Windows NT 6.1; rv:2.2) Gecko/20110201")
    puts URI.escape(url) 
    File.open(File.join(@dir, url.split("/").last), "w") do |f|
      f << page.read
    end
    page.close
  end

	#####
	# parse links for each league
	# save in instance hash
	#####
  def load_and_parse_navigation(nav_url="https://www.tipico.com/de/online-sport-wetten")
		# download home page
		load(nav_url)
    f = IO.read(File.join(@dir, nav_url.split("/").last))
    doc = Hpricot.XML(f)

    link_hash = {} 
 		(doc/"a.nav_main_1").each do |sport|
			sportname = (sport/"div.left").inner_text.strip
      link = sport["href"]
      if @sports.include? sportname then
        url = "https://www.tipico.com#{link}"
        load(url)

        @link_hash[sportname] = {} unless @link_hash.include? sportname

        file = IO.read(File.join(@dir, url.split("/").last))
        d = Hpricot.XML(file)

        # parse for leagues

        (d/"li.line").each do |region|
          regionname = (region/"div.nav_main_2"/"span.left").inner_text.strip
          @link_hash[sportname][regionname] = {} unless @link_hash[sportname].include? regionname
          (region/"li.sub").each do |league|
            leaguename = (league/"span.left").inner_text.strip
            league_link = (league/:a).first["href"]
            @link_hash[sportname][regionname][leaguename] = league_link
          end
        end

      end
    end

  end

	def load_and_parse
		@sports.each do |sport, regions|
    regions.each do |region, leagues|
    leagues.each do |league|
			url = "https://www.tipico.com#{@link_hash[sport][region][league]}"
			load(url)
    	doc = Hpricot(open(File.join(@dir, url.split("/").last)))

			(doc/"div[@class='col']").each do |each_date|
				date = (each_date/"div.col_10").inner_text.strip[/(\d+.\d+.)/,1]
					
				node = each_date.next_sibling
				begin
					break if node["class"] == "col"
          game_name = (node/"div.col_7").inner_text.strip
          home_name = game_name[/(.+?) - (.+)/, 1]
          away_name = game_name[/(.+?) - (.+)/, 2]
					puts "#{home_name} vs. #{away_name}"

          time = (node/"div.col_1").inner_text.strip

          game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(home_name, away_name)
                
          #starttime
          Time.zone = "UTC"
          game.starttime = Time.strptime("#{date}T#{time}", "%d.%m.T%H:%M") 
          game.save

          odd1 = (node/"div.col_5")[0].inner_text.strip.gsub(",",".")
          oddX = (node/"div.col_5")[1].inner_text.strip.gsub(",",".")
          odd2 = (node/"div.col_5")[2].inner_text.strip.gsub(",",".")

          betname = "3Way"
          odd = game.odds.find_or_create_by_betname(betname)

          odd.home = odd1
          odd.draw = oddX
          odd.away = odd2
          odd.save
          #
          odd.touch

					node = node.next_sibling
				end while not node.nil?

			end
        
		end
  	end
    end
  end

  # loop
  def run
    # first: load entire feed
    begin
      self.load
      self.parse
    end unless File.exists(File.join(@dir, "pinnacleFeed.asp"))

    while true do
      time = File.stat(File.join(@dir, "pinnacleFeed.asp")).mtime
      # wait at least 5 min
      while Time.now - 5.minutes < time do
        puts "sleep..."
        sleep 30
      end
      # only load new odds
      self.load_next
      self.parse
    end
  end

  private

  def parse_Match(game, infos)
		odds = (infos/"td.uTdInnerBetTd")
		odd1 = odds[0].inner_text.strip
		oddX = odds[1].inner_text.strip
		odd2 = odds[2].inner_text.strip
    
    if oddX.empty? 
      betname = "2Way"
    else
      betname = "3Way"
    end

    odd = game.odds.find_or_create_by_betname(betname)

    odd.odd1 = odd1
    odd.oddX = oddX
    odd.odd2 = odd2
    odd.save
    #
    odd.touch

  end

end

#tip = TipicoScraper.new
#tip.load_and_parse_navigation
#tip.load_and_parse
