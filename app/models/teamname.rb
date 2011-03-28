class Teamname < ActiveRecord::Base
  belongs_to :bookmaker
  # self joining
  has_many :subnames, :class_name => "Teamname", :foreign_key => "mainname"
  belongs_to :mainname, :class_name => "Teamname"
  #
  has_many :bookie_games

  # validations
  validates_uniqueness_of :name, :scope => :bookmaker_id
  validates_presence_of :name

  def is_main?
    self.main
  end

  # returns all unmapped teamnames
  def self.unmapped
    self.where(:mainname_id => null).where(:main => false).all
  end
    
  def to_s
    self.name
  end
end
