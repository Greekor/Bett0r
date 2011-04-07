require 'hpricot'
require 'open-uri'

=begin

implemented bettypes:
  2Way / 3Way
  Over/Under (Total)
  
implemented sports:
  Baseball: MLB Spring Training
            MLB
  Soccer:   Germany Bundesliga
            Germany 2. Liga
            England Premier League
            Spain Primera Division
            Italy Serie A


=end


class BetAtHomeScraper
  # constructor
  def initialize(sports={"Baseball"=>["MLB Spring Training", "MLB"], "Soccer"=>["Germany Bundesliga", "Germany 2. Liga", "England Premier League", "Spain Primera Division", "Italy Serie A" ]})
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


        if self.class.private_method_defined? "parse_#{betname}" then
          home_name = (oddsData/:HomeTeam).inner_html
          away_name = (oddsData/:AwayTeam).inner_html
          game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(home_name, away_name)
        
          # starttime
          Time.zone = "CET"
          game.starttime = Time.zone.parse starttime
          game.save

          # odds
          send "parse_#{betname}", game, oddsData

          puts "+++"
          puts game.inspect
          puts "---"
        end
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

  private

  # methods for parsing different bettypes

  # 2way odds
  def parse_2W(game, oddsData)
    betname = "2W"
    odd = game.odds.find_or_create_by_betname(betname)

    odd1 = (oddsData/:HomeOdds).inner_html
    odd2 = (oddsData/:AwayOdds).inner_html
        
    odd.odd1 = odd1
    odd.odd2 = odd2
    odd.save
    # set updated_at
    odd.touch
  end

  # 3way odds
  def parse_3W(game, oddsData)
    betname = "3W"
    odd = game.odds.find_or_create_by_betname(betname)

    odd1 = (oddsData/:HomeOdds).inner_html
    oddX = (oddsData/:DrawOdds).inner_html
    odd2 = (oddsData/:AwayOdds).inner_html
        
    odd.odd1 = odd1
    odd.oddX = oddX
    odd.odd2 = odd2
    odd.save
    # set updated_at
    odd.touch
  end

  # total odds
  def parse_Total(game, oddsData)
    betname = "Over/Under #{(oddsData/:Totalscore).inner_html}"
    odd = game.odds.find_or_create_by_betname(betname)

    over = (oddsData/:OverOdds).inner_html
    under = (oddsData/:UnderOdds).inner_html

    odd.over = over
    odd.under = under
    odd.save
    #set updated_at
    odd.touch
  end

end

#b = BetAtHomeScraper.new
#b.load
#b.parse
