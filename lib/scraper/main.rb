require File.expand_path File.join(File.dirname(__FILE__), 'pinnacle/pinnacle.rb')
require File.expand_path File.join(File.dirname(__FILE__), 'expekt/expekt.rb')
require File.expand_path File.join(File.dirname(__FILE__), 'betathome/betathome.rb')

@dir = File.dirname(__FILE__)

pinn = PinnacleScraper.new
bah = BetAtHomeScraper.new
exp = ExpektScraper.new
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
end
