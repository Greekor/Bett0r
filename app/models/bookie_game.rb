class BookieGame < ActiveRecord::Base
  belongs_to :bookmaker
  belongs_to :game
  belongs_to :home, :class_name => "Teamname"
  belongs_to :away, :class_name => "Teamname"
  has_many :odds do
    def find_or_create_by_betname(name)
      find_or_create_by_bettype_id(Bettype.find_or_create_by_bookmaker_id_and_name(proxy_owner.bookmaker_id, name).id)
    end
  end


  # callbacks
  before_save :map_teamnames, :if => :names_mapable?
  before_save :map_to_game, :if => :mapable?

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

  def mapable?
    # both teamnames not nil?
    bool = bool && !self.home_id.nil? && !self.away_id.nil?
    # both teamnames mapped?
    bool = bool && (!Teamname.find(self.home_id).mainname_id.nil? || Teamname.find(self.home_id).main) && (!Teamname.find(self.away_id).mainname_id.nil? || Teamname.find(self.away_id).main)
    puts bool
    bool
  end

  def map_to_game
    puts "Map BookieGame to Game"
    home = Teamname.find(self.home_id)
    away = Teamname.find(self.away_id)
    if home.main
      game = Game.find_or_create_by_home_id_and_away_id(home.id, away.id)
      self.game_id = game.id
    else
      game = Game.find_or_create_by_home_id_and_away_id(home.mainname_id, away.mainname_id)
      self.game_id = game.id
    end
  end

  # looks up teamnames in db
  def map_teamnames
    home = self.bookmaker.teamnames.find_or_create_by_name(self.home_name)
    away = self.bookmaker.teamnames.find_or_create_by_name(self.away_name)

    self.home_id = home.id unless home.nil?
    self.away_id = away.id unless away.nil?
  end
end
