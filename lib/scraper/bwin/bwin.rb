require 'hpricot'
require 'open-uri'

=begin

implemented bettypes:
	3Way

implemented sports:
	Fußball =>
		Deutschland => Bundesliga
		England => Premier League
		Spanien => Primera Division

=end

class BWinScraper
  # constructor
  def initialize(sports={
  			"fu%C3%9Fball" => {
  				"Deutschland" => [ "Bundesliga" ],
  				"England" => [ "Premier League" ],
  				"Spanien" => [ "Primera Division (Liga BBVA)" ]
  			}  			
  			})
    @sports = sports
    @bookie = Bookmaker.find_or_create_by_name("BWin")
    @dir = File.dirname(__FILE__)
    @leagueids = {}
  end
  
  def load(url)
    page = open(url)
    File.open(File.join(@dir, url.split("/").last), "w") do |f|
      f << page.read
    end
    page.close
  end
  
  def get_league_ids
  	main_url = "https://www.bwin.com/de/"
  	@sports.each_key do |sport|
  		@leagueids[sport] = {} unless @leagueids.include? sport
  	
  		load(main_url+sport)
			doc = Hpricot(open(File.join(@dir, sport)))

			(doc/"div.sportNavigationLeague").each do |e|
			leaguename = e.inner_text.strip[/(.+?) \(\d+\)/,1]
			leagueid = (e/:a).first["href"][/\d+/]
				regionname =  e.preceding_siblings.search("a.sportsNavigationArrowButtonNew").last.inner_text
				@leagueids[sport][regionname] = {} unless @leagueids[sport].include? regionname
				@leagueids[sport][regionname][leaguename] = leagueid
			end
		end
	end

  def load_and_parse
  	main_url = "https://www.bwin.com/de/betViewIframe.aspx?selectedLeagues=1&leagueids="
  	@sports.each do |sport, regions|
  		regions.each do |region, leagues|
  			leagues.each do |league|
  				url = main_url+@leagueids[sport][region][league] 
  				load(url)
  				doc = Hpricot(open(File.join(@dir, url.split("/").last)))
  				
  				(doc/"div.dsBodyLeft").each do |day|
						date = (day/"span.spanInnerLeft").inner_text.strip
						(day/"tr.normal").each do |game|
							cols = (game/"/td")
							time = cols[0].inner_text.strip
							home_name = (cols[1]/"td.label").inner_text.strip
							odd1 = (cols[1]/"td.odd").inner_text.strip
							oddX = (cols[2]/"td.odd").inner_text.strip
							odd2 = (cols[3]/"td.odd").inner_text.strip
							away_name = (cols[3]/"td.label").inner_text.strip

							game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(home_name, away_name)
							
							#starttime
		          Time.zone = "CET"
		          game.starttime = Time.parse("#{date}T#{time}")
		          game.save
		          
		          betname = "3Way"
					    odd = game.odds.find_or_create_by_betname(betname)

					    odd.odd1 = odd1
					    odd.oddX = oddX
					    odd.odd2 = odd2
					    odd.save
					    #
					    odd.touch
		          
							puts "#{date}T#{time}: #{home_name} vs. #{away_name} #{odd1} - #{oddX} - #{odd2}"
							puts
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

end
