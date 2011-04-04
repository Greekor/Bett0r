require 'hpricot'
require 'open-uri'

class ExpektScraper
  # constructor
  def initialize(sports=["Ger. 1. Bundesliga", "MLB Preseason", "MLB"])
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
        puts "-- #{description} --"
        if /(?<home>.+?) - (?<away>[^<:]+)[^:]+(: )?(?<bettype>.*)/ =~ description then
          infos[:home_name] = home.strip
          infos[:away_name] = away.strip
          infos[:bettype] = bettype.strip
        end
        #

        if (event/:alternatives/:alternative).size == 3 then
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

          puts "Bettype: #{infos[:bettype]}"
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
end

