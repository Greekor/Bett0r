require 'hpricot'
require 'open-uri'

class BetAtHomeScraper
  # constructor
  def initialize(sports={"Baseball"=>["MLB Spring Training"], "Soccer"=>["Germany Bundesliga"]})
    @sports = sports
    @bookie = Bookmaker.find_or_create_by_name("BetAtHome")
    @dir = File.dirname(__FILE__)
  end

  def load
    url = "http://www.bet-at-home.com/oddxml.aspx"

    page = open(url)
    File.open(File.join(@dir, "oddxml.aspx"), "w") do |f|
      f << page.read
    end
    page.close
  end

  def parse
    f = IO.read(File.join(@dir, "oddxml.aspx"))
    doc = Hpricot.XML(f)

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

  # loop
  def run
    while true do
      time = File.stat(File.join(@dir, "oddxml.aspx")).mtime
      # wait at least 5 min
      while Time.now - 5.minutes < time do
        puts "sleep..."
        sleep 60
      end
      # load and parse
      self.load
      self.parse
    end
  end
end
