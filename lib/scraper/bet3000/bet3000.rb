# encoding: UTF-8
require 'hpricot'
require 'open-uri'

=begin

implemented bettypes:
  3WAY

implemented sports:
  Fußball =>
     Deutschland => 1. Bundesliga, 2. Bundesliga
     England => Premier League
     Spanien => Primera Division
     Italien => Serie A

=end

class Bet3000Scraper
  # constructor
  def initialize(sports=
        {"Fußball" => 
          { "Deutschland" => [ "1. Bundesliga", "2. Bundesliga" ],
            "England" => [ "Premier League" ],
            "Spanien" => [ "Primera Division" ],
            "Italien" => [ "Serie A" ],
          }
        } )
		@sports = sports
    @bookie = Bookmaker.find_or_create_by_name("Bet3000")
    @dir = File.dirname(__FILE__)
		@cat_hash = {}
  end

  def load(url)
    page = open(url)
    File.open(File.join(@dir, url.split("/").last), "w") do |f|
      f << page.read
    end
    page.close
  end

	#####
	# parse links for each league
	# save in instance hash
	#####
  def load_and_parse_navigation(nav_url="https://www.bet3000.com/de/html/home.html")
		# download home page
		load(nav_url)
    f = IO.read(File.join(@dir, nav_url.split("/").last))
    doc = Hpricot.XML(f)
  
		sidebar = (doc/"ul#category_tree.tree")
		(sidebar/"li.top").each do |sport|
			regions = (sport/:ul)
			sportname = (sport/"/a").inner_html.strip
      @cat_hash[sportname] = {} unless @cat_hash.include? sportname
			(regions/"/li").each do |region|
				leagues = (region/"/ul")
				regionname = (region/"/a").inner_html.strip
        @cat_hash[sportname][regionname] = {} unless @cat_hash[sportname].include? regionname
				(leagues/"/li").each do |league|
					leaguename = (league/"/a").inner_html.strip
					link = (league/"/a").first[:href]
					cat_id = link[/category_id=(\d+)/, 1]
					@cat_hash[sportname][regionname][leaguename] = cat_id
				end
			end
		end
  end

  def create_event_to_date(data_hash)
    result = {}
    data_hash["layout"].each do |hash|
      date = hash["date"]
      hash["categories"].each do |subhash|
        subhash["events"].each do |eventid|
          result[eventid] = date
        end
      end
    end
    result
  end

	def load_and_parse
		@sports.each do |sport, regions|
    regions.each do |region, leagues|
    leagues.each do |league|
			url = "https://www.bet3000.com/ajax/de/sportsbook.json.html?category_id=#{@cat_hash[sport][region][league]}"
			load(url)
    	json = IO.read(File.join(@dir, url.split("/").last))[11..-4]
      data_hash = ActiveSupport::JSON.decode(json)

      event_to_date = create_event_to_date(data_hash)

      data_hash["markets"].each do |id, hash|
        event = data_hash["events"][hash["event_id"]]
        bettype = hash["type"]
        date = event_to_date[hash["event_id"]][/\S+, (.+)/,1]
        time = event["expires"]

        home_name = event["label"][/(.+?) - (.+)/, 1]
        away_name = event["label"][/(.+?) - (.+)/, 2]
       
        infos = {} 
        hash["predictions"].each do |prediction_id|
          prediction = data_hash["predictions"][prediction_id]
          infos[prediction["type"]] = prediction["odds"]
        end

        if self.class.private_method_defined? "parse_#{bettype}" then
          game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(home_name, away_name)

          #starttime
          Time.zone = "CET"
          game.starttime = Time.strptime("#{date}T#{time}", "%d.%mT%H:%M")
          game.save

          #odds
          send "parse_#{bettype}", game, infos
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

  def parse_3WAY(game, infos)
    betname = "3Way"
    odd = game.odds.find_or_create_by_betname(betname)

    odd.odd1 = infos["home"]
    odd.oddX = infos["draw"]
    odd.odd2 = infos["visitor"]
    odd.save
    #
    odd.touch
  end

end

#b = Bet3000Scraper.new
#b.load_and_parse_navigation
#b.load_and_parse
