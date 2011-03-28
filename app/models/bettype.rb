class Bettype < ActiveRecord::Base
  belongs_to :bookmaker
  # self joining
  has_many :subtypes, :class_name => "Bettype", :foreign_key => "maintype_id"
  belongs_to :maintype, :class_name => "Bettype"
  has_many :odds

  # validations
  validates_uniqueness_of :name, :scope => :bookmaker_id
  validates_presence_of :name

  def is_main?
    self.main
  end

  # returns all unmapped bettypes
  def self.unmapped
    self.where(:maintype_id => null).where(:main => false).all
  end

  def to_s
    self.name
  end

  # returns maintype object (either itself or "real" maintype)
  def maintype
    type = Bettype.find(self.maintype_id) unless self.is_main? || self.maintype_id.nil?
    type = self if self.is_main?
    type
  end

end
