require 'hpricot'
require 'open-uri'

=begin
    
implemented bettypes:
  2Way / 3Way
  Over/Under
implemented sports:
  Basketball: NBA
  Baseball: MLB Preseason
            MLB
  Soccer: Ger. 1. Bundesliga
          Ger. 2. Bundesliga
          Eng. Premier League
          Spa. Primera Division
          Ita. Serie A

=end

class ExpektScraper
  # constructor
  def initialize(sports=["Ger. 1. Bundesliga", "Ger. 2. Bundesliga", "Eng. Premier League", "MLB Preseason", "MLB", "Spa. Primera Division", "Ita. Serie A", "NBA"])
    @sports = sports
    @bookie = Bookmaker.find_or_create_by_name("Expekt")
    @dir = File.dirname(__FILE__)
  end

  def load
    url = "http://www.expekt.com/exportServlet"

    page = open(url)
    File.open(File.join(@dir, "exportServlet"), "w") do |f|
      f << page.read
    end
    page.close
  end

  def parse
    f = IO.read(File.join(@dir, "exportServlet"))
    doc = Hpricot.XML(f)

    # each event
    (doc/:game).each do |event|
      starttime = event["date"]+"T"+event["time"]
      league = (event/:description/:category).inner_html
      if @sports.include?(league) then

        infos = {}
        # regexp
        description = (event/:description).text.sub(league, "").strip
        if /(?<home>.+?) - (?<away>[^<:]+)[^:]*(: )?(?<bettype>.*)/ =~ description then
          infos[:home_name] = home.strip
          infos[:away_name] = away.strip
          infos[:bettype] = bettype.strip
        end
        #

        betmethod = "parse_#{infos[:bettype].gsub("/","_")}" unless infos[:bettype].nil?
        if !(infos[:bettype].nil?) && self.class.private_method_defined?(betmethod) then
          game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(infos[:home_name], infos[:away_name])

          # starttime
          Time.zone = "CET"
          game.starttime = Time.zone.parse starttime
          game.save

          # odds
          send betmethod, game, (event/:alternatives/:alternative)
        
          puts "+++"
          puts "#{infos[:home_name]} vs. #{infos[:away_name]}"  
          puts game.inspect
          puts "---"
        end
      end
    end
  end

  # loop
  def run
    while true do
      time = File.stat(File.join(@dir, "exportServlet")).mtime
      # wait at least 5 min
      while Time.now - 5.minutes < time do
        puts "sleep..."
        sleep 60
      end
      # load
      self.load
      self.parse
    end
  end

  private 

  # methods for parsing different bettypes

  # 2Way AND 3Way
  def parse_(game, odds)
    parse_1x2(game, odds)
  end
  def parse_1x2(game, odds)
    odd1 = odds[0]["odds"]
    oddX = odds[1]["odds"]
    odd2 = odds[2]["odds"]

    betname = (oddX == "0.00") ? "Game - 2W" : "Game - 3W"
          
    odd = game.odds.find_or_create_by_betname(betname)
    odd.home = odd1
    odd.draw = oddX unless oddX == "0.00"
    odd.away = odd2
    odd.save
    # set updated_at
    odd.touch
  end

  # Over/Under
  def parse_Over_under(game, odds)
    betname = "over/under"
    if /(?<n>\d(.\d)?)/ =~ odds[0].inner_html then
      betname += " #{n}"
    end
    under = odds[0]["odds"]
    over = odds[1]["odds"]

    odd = game.odds.find_or_create_by_betname(betname)
    odd.over = over
    odd.under = under
    odd.save
    # set updated_at
    odd.touch
  end

end

#e = ExpektScraper.new
#e.load
#e.parse
