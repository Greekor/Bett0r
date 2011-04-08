class BookieGame < ActiveRecord::Base
  belongs_to :bookmaker
  belongs_to :game
  belongs_to :home, :class_name => "Teamname"
  belongs_to :away, :class_name => "Teamname"
  has_many :odds, :dependent => :destroy do
    def find_or_create_by_betname(name)
      find_or_create_by_bettype_id(Bettype.find_or_create_by_bookmaker_id_and_name(proxy_owner.bookmaker_id, name).id)
    end
  end


  # callbacks
  before_save :map_teamnames, :if => :names_mapable?
  before_save :map_to_game, :if => :game_mapable?

  # attributes not stores in db
  def home_name=(n)
    @home_name = n
  end

  def home_name
    if self.home_id.nil?
      @home_name
    else
      Teamname.find(self.home_id).to_s
    end
  end

  def away_name=(n)
    @away_name = n
  end

  def away_name
    if self.away_id.nil?
      @away_name
    else
      Teamname.find(self.away_id).to_s
    end
  end

  # own finder
  def self.find_or_create_by_bookmaker_id_and_home_name_and_away_name(bookie_id, hname, aname)
    self.find_or_create_by_bookmaker_id_and_home_id_and_away_id(bookie_id, Teamname.find_or_create_by_bookmaker_id_and_name(bookie_id, hname).id, Teamname.find_or_create_by_bookmaker_id_and_name(bookie_id, aname).id)
  end

  def to_s
    "#{self.home} - #{self.away}"
  end

  ###############
  # private methods
  ###############
  private

  # home_name AND away_name not nil?
  def names_mapable?
    !(home_name.nil? || away_name.nil?)
  end

  def game_mapable?
    bool = !self.starttime.nil?
    # both teamnames not nil?
    bool = bool && !self.home_id.nil? && !self.away_id.nil?
    # both teamnames mapped?
    bool = bool && (!Teamname.find(self.home_id).mainname_id.nil? || Teamname.find(self.home_id).main) && (!Teamname.find(self.away_id).mainname_id.nil? || Teamname.find(self.away_id).main)
    bool
  end

  def map_to_game
    puts "Map BookieGame to Game"
    home = Teamname.find(self.home_id)
    away = Teamname.find(self.away_id)
   
    # find game 
    game = Game.where(:starttime => (read_attribute(:starttime)-2.hours)..(read_attribute(:starttime)+2.hours)).find_by_home_id_and_away_id(home.main ? home.id : home.mainname_id, away.main ? away.id : away.mainname_id)

    game.odds.alias_attribute :home, :odd1 unless game.nil?
    game.odds.alias_attribute :draw, :oddX unless game.nil?
    game.odds.alias_attribute :away, :odd2 unless game.nil?

    # if not found, change home<=>away
    if game.nil? then
      game = Game.where(:starttime => (read_attribute(:starttime)-2.hours)..(read_attribute(:starttime)+2.hours)).find_by_away_id_and_home_id(home.main ? home.id : home.mainname_id, away.main ? away.id : away.mainname_id)

      # inverse!!
      game.odds.alias_attribute :home, :odd2 unless game.nil?
      game.odds.alias_attribute :draw, :oddX unless game.nil?
      game.odds.alias_attribute :away, :odd1 unless game.nil?
    end
    # if still not found, create new game
    if game.nil? then
      game = Game.new(:home_id => (home.main ? home.id : home.mainname_id) ,:away_id => (away.main ? away.id : away.mainname_id))
      game.starttime = read_attribute(:starttime)
      game.save

      game.odds.alias_attribute :home, :odd1 unless game.nil?
      game.odds.alias_attribute :draw, :oddX unless game.nil?
      game.odds.alias_attribute :away, :odd2 unless game.nil?
    end
    self.game_id = game.id
  end

  # looks up teamnames in db
  def map_teamnames
    home = self.bookmaker.teamnames.find_or_create_by_name(self.home_name)
    away = self.bookmaker.teamnames.find_or_create_by_name(self.away_name)

    self.home_id = home.id unless home.nil?
    self.away_id = away.id unless away.nil?
  end
end
