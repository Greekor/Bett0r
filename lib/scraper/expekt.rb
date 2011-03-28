require 'hpricot'

class ExpektScraper
  # constructor
  def initialize(sports=["Ger. 1. Bundesliga", "MLB Preseason"])
    @sports = sports
    @bookie = Bookmaker.find_or_create_by_name("Expekt")
  end

  def load_xml
    @xml = IO.read("lib/scraper/exportServlet")
  end

  def parse
    doc = Hpricot.XML(@xml)

    # each event
    (doc/:game).each do |event|
      starttime = event["date"]+"T"+event["time"]
      league = (event/:description/:category).inner_html
      if @sports.include?(league) then

        infos = {}
        # regexp
        description = (event/:description).text.sub(league, "").strip
        puts "-- #{description} --"
        if /(?<home>.+) - (?<away>[^:]+)(: )?(?<bettype>.*)/ =~ description then
          infos[:home_name] = home.strip
          infos[:away_name] = away.strip
          infos[:bettype] = bettype.strip
        end
        #

        odd1 = (event/:alternatives/:alternative)[0]["odds"]
        oddX = (event/:alternatives/:alternative)[1]["odds"]
        odd2 = (event/:alternatives/:alternative)[2]["odds"]

        if infos[:bettype].empty? then
          infos[:bettype] = "Game - 2W" if oddX == "0.00"
          infos[:bettype] = "Game - 3W" unless oddX == "0.00"
        end

        game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(infos[:home_name], infos[:away_name])

        Time.zone = "CET"
        game.starttime = Time.zone.parse starttime
        game.save

        puts infos[:bettype]
        odd = game.odds.find_or_create_by_betname(infos[:bettype])
        odd.odd1 = odd1
        odd.oddX = oddX unless oddX == "0.00"
        odd.odd2 = odd2
        odd.save
        # set updated_at
        odd.touch

        puts "+++"
        puts "#{infos[:home_name]} vs. #{infos[:away_name]}"
        puts game.inspect
        puts "---"
      end
    end
  end
end

scraper = ExpektScraper.new
scraper.load_xml
scraper.parse
