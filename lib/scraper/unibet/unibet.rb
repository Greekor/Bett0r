# encoding: UTF-8
require 'hpricot'
require 'uri'
require 'open-uri'

=begin

implemented bettypes:
  3WAY/2WAY
implemented sports:
  Baseball =>
    MLB
  Basketball =>
    NBA
  Soccer =>
    Deutschland => Bundesliga, 2.Bundesliga
    England => Premier League
    Spanien => Primera Division
    Italien => Serie A


=end

class UnibetScraper
  # constructor
  def initialize(sports={
      "Baseball" => {
        "MLB" => [ "Regular Season" ]
      },
      "Basketball" => {
        "NBA" => [ "Regular Season" ]
      },
			"All Football" => {
					"Germany" => [ "Bundesliga", "2.Bundesliga" ],
          "England" => [ "Premier League" ],
          "Spain" => [ "Primera División" ],
          "Italy" => [ "Serie A" ]
			}
		} )
		@sports = sports
    @bookie = Bookmaker.find_or_create_by_name("Unibet")
    @dir = File.dirname(__FILE__)
		@link_hash = {}
  end

  def load(url)
    page = open(URI.escape(url))
    File.open(File.join(@dir, url.split("/").last), "w") do |f|
      f << page.read
    end
    page.close
  end

	#####
	# parse links for each league
	# save in instance hash
	#####
  def load_and_parse_navigation(nav_url="https://www.unibet.com/betting")
		# download home page
		load(nav_url)
    f = IO.read(File.join(@dir, nav_url.split("/").last))
    doc = Hpricot.XML(f)
 
 		(doc/"ul.uHide/li").each do |sport|
			sportname = (sport/"/dl/dd/a").inner_text.strip
			@link_hash[sportname] = {} unless @link_hash.include? sportname
			(sport/"//ul/li").each do |region|
				regionname = (region/"/dl/dd/a").inner_text.strip
				@link_hash[sportname][regionname] = {} unless @link_hash[sportname].include? regionname
				(region/"//ul/li").each do |league|
					leaguename = (league/"/dl/dd/a").inner_text.strip
					link = (league/"/dl/dd/a").first["href"]
					@link_hash[sportname][regionname][leaguename] = link
				end
			end
		end
  end

	def load_and_parse
		@sports.each do |sport, regions|
    regions.each do |region, leagues|
    leagues.each do |league|
			url = "https://www.unibet.com#{@link_hash[sport][region][league]}"
			puts url
			load(url)
    	doc = Hpricot(open(File.join(@dir, url.split("/").last)))

			(doc/"table.uTableBetOffer/thead").each do |head|
				betname = head.inner_text.strip

				if self.class.private_method_defined? "parse_#{betname}" then
					body = (head/"../tbody")
					(body/".uTrLevel3").each do |each_date|
						date = (each_date/:td).first.inner_text.strip

						node = each_date.next_sibling
						begin
							break if node["class"] == "uTrLevel3"
							if node["class"] == "uTrLevel5" then
								home_name =  (node/".uTdInnerTeam")[0].inner_text.strip
								away_name =  (node/".uTdInnerTeam")[1].inner_text.strip
								puts "#{home_name} vs. #{away_name}"

                time = (node/:td)[0].inner_text.strip
                game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(home_name, away_name)
                
                #starttime
                Time.zone = "UTC"
                game.starttime = Time.parse("#{date}T#{time}")
                game.save
      
								send "parse_#{betname}", game, node
							end
							node = node.next_sibling
						end while not node.nil?

					end
				end
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

#uni = UnibetScraper.new
#uni.load_and_parse_navigation
#uni.load_and_parse
