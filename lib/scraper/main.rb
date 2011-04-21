require File.expand_path File.join(File.dirname(__FILE__), 'pinnacle/pinnacle.rb')
require File.expand_path File.join(File.dirname(__FILE__), 'expekt/expekt.rb')
require File.expand_path File.join(File.dirname(__FILE__), 'betathome/betathome.rb')
require File.expand_path File.join(File.dirname(__FILE__), 'bet3000/bet3000.rb')
require File.expand_path File.join(File.dirname(__FILE__), 'bwin/bwin.rb')

@dir = File.dirname(__FILE__)

pinn = PinnacleScraper.new
bah = BetAtHomeScraper.new
exp = ExpektScraper.new
b30 = Bet3000Scraper.new
bwin = BWinScraper.new

# loop
while true do
  puts "PinnacleScraper"
  time = File.stat(File.join(@dir, "pinnacle/pinnacleFeed.asp")).mtime
  # wait at least 5 min
  while Time.now - 5.minutes < time do
    puts "sleep..."
    sleep 30
  end
  # only load new odds
  pinn.load_next
  pinn.parse

  puts "BetAtHomeScraper"
  time = File.stat(File.join(@dir, "betathome/oddxml.aspx")).mtime
  # wait at least 5 min
  while Time.now - 5.minutes < time do
    puts "sleep..."
    sleep 30
  end
  # only load new odds
  bah.load
  bah.parse

  puts "Expekt"
  time = File.stat(File.join(@dir, "expekt/exportServlet")).mtime
  # wait at least 5 min
  while Time.now - 5.minutes < time do
    puts "sleep..."
    sleep 30
  end
  # only load new odds
  exp.load
  exp.parse
  
  puts "Bet3000"
  time = File.stat(File.join(@dir, "bet3000/home.html")).mtime
  # wait at least 5 min
  while Time.now - 5.minutes < time do
    puts "sleep..."
    sleep 30
  end
  # only load new odds
  b30.load_and_parse_navigation
	b30.load_and_parse
	
	puts "BWin"
  time = File.stat(File.join(@dir, "bwin/football")).mtime
  # wait at least 5 min
  while Time.now - 5.minutes < time do
    puts "sleep..."
    sleep 30
  end
  # only load new odds
	bwin.get_league_ids
	bwin.load_and_parse
end
