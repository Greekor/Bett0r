require 'hpricot'
require 'open-uri'

class PinnacleScraper
  # constructor
  def initialize(sports={"Baseball"=>["MLB"], "Soccer"=>["Bundesliga"]})
    @sports = sports
    @bookie = Bookmaker.find_or_create_by_name("PinnacleSports")
  end

  def load_xml(time=nil)
    url = "http://xml.pinnaclesports.com/pinnacleFeed.asp"
    url << "?last=#{time}" unless time.nil?

    puts "get: #{url}"

    @xml = IO.read("lib/scraper/pinnacleFeed.asp")
  end

  def parse
    doc = Hpricot.XML(@xml)
    feedtime = (doc/:pinnacle_line_feed/:PinnacleFeedTime).inner_html
    puts "Feed Time: #{feedtime}"

    (doc/:pinnacle_line_feed/:events/:event).each do |event|
      # only wanted sports...with valid data
      starttime = (event/:event_datetimeGMT).inner_html
      sporttype = (event/:sporttype).inner_html
      league = (event/:league).inner_html
      if @sports.include?(sporttype) && @sports[sporttype].include?(league) && (event/:periods/:period).size > 0 then

        gameinfos = {}

        (event/:participants/:participant).each do |participants|
          name = (participants/:participant_name).inner_html
          vhd = (participants/:visiting_home_draw).inner_html
          gameinfos[:home_name] = name if vhd == "Home"
          gameinfos[:away_name] = name if vhd == "Visiting"
        end
 
        puts "+++"
        puts "#{gameinfos[:home_name]} vs. #{gameinfos[:away_name]}"
        puts "+++"
  
        game = @bookie.bookie_games.find_or_create_by_home_name_and_away_name(gameinfos[:home_name], gameinfos[:away_name])

        Time.zone = "GMT"
        game.starttime = Time.zone.parse starttime
        game.save

        (event/:periods/:period).each do |period|
          # only whole game
          if (period/:period_number).inner_html == "0" then
            # only moneyline
            moneyline = (period/:moneyline)
            if moneyline.size > 0 then
              if (moneyline/:moneyline_draw).size > 0 then
                betname = "Game - Moneyline - 3Way"
              else
                betname = "Game - Moneyline - 2Way" 
              end
              odd = game.odds.find_or_create_by_betname(betname)
              odd.odd1 = to_dec (moneyline/:moneyline_home).inner_html
              odd.oddX = to_dec (moneyline/:moneyline_draw).inner_html if (moneyline/:moneyline_draw).size > 0
              odd.odd2 = to_dec (moneyline/:moneyline_visiting).inner_html
              odd.save
              # set updated_at even if nothing has changed
              odd.touch
            end
          end
        end
     
       
      end 
    end
  end


  # converts from american style odds into decimal
  def to_dec(am)
    am = am.to_f
    dec = (100 / (-am)) + 1 if am < 0
    dec = (am / 100) + 1 if am > 0
    dec.round(3)
  end
end

scraper = PinnacleScraper.new
scraper.load_xml
scraper.parse
