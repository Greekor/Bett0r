require 'hpricot'

class BetAtHomeScraper
  # constructor
  def initialize(sports={"Baseball"=>["MLB Spring Training"], "Soccer"=>["Germany Bundesliga"]})
    @sports = sports
    @bookie = Bookmaker.find_or_create_by_name("BetAtHome")
  end

  def load_xml
    @xml = IO.read("lib/scraper/oddxml.aspx")
  end

  def parse
    doc = Hpricot.XML(@xml)

    # each event
    (doc/:Betradar/:OO).each do |event|
      starttime = (event/:Date).inner_html
      sporttype = (event/:Sport).inner_html
      league = (event/:Tournament).inner_html
      if @sports.include?(sporttype) && @sports[sporttype].include?(league) then

        betname = (event/:OddsType).inner_html
        oddsData = (event/:OddsData)
        home_name = (oddsData/:HomeTeam).inner_html
        away_name = (oddsData/:AwayTeam).inner_html
        odd1 = (oddsData/:HomeOdds).inner_html
        oddX = (oddsData/:DrawOdds).inner_html if (oddsData/:DrawOdds).size>0
        odd2 = (oddsData/:AwayOdds).inner_html

        game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(home_name, away_name)

        Time.zone = "CET"
        game.starttime = Time.zone.parse starttime
        game.save

        odd = game.odds.find_or_create_by_betname(betname)
        odd.odd1 = odd1
        odd.oddX = oddX
        odd.odd2 = odd2
        odd.save
        # set updated_at
        odd.touch

        puts "+++"
        puts game.inspect
        puts "---"
      end
    end
  end
end

scraper = BetAtHomeScraper.new
scraper.load_xml
scraper.parse
