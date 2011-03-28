class Bookmaker < ActiveRecord::Base
  has_many :bookie_games do
    def find_or_create_by_home_name_and_away_name(hname, aname)
      BookieGame.find_or_create_by_bookmaker_id_and_home_name_and_away_name(proxy_owner.id, hname, aname)
    end
  end
  has_many :teamnames do
    def unmapped
      find(:all, :conditions => { :mainname_id => nil, :main => false})
    end
  end
  has_many :bettypes do
    def unmapped
      find(:all, :conditions => { :mainname_id => nil, :main => false})
    end
  end

  # validations
  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    self.name.to_s
  end
end
