class Game < ActiveRecord::Base
  has_many :bookie_games
  has_many :odds, :through => :bookie_games do
    def by_bettype
      hash = {}
      self.each do |odd|
        # key already in hash?
        if !(odd.bettype.maintype.nil?)
          if hash.include? odd.bettype.maintype then
            hash[odd.bettype.maintype] << odd
          else
            hash[odd.bettype.maintype] = []
            hash[odd.bettype.maintype] << odd
          end
        else
          if hash.include? odd.bettype then
            hash[odd.bettype] << odd
          else
            hash[odd.bettype] = []
            hash[odd.bettype] << odd
          end
        end
      end 
      hash
    end
  end

  belongs_to :home, :class_name => "Teamname"
  belongs_to :away, :class_name => "Teamname"

  def to_s
    "#{Teamname.find(self.home_id)} - #{Teamname.find(self.away_id)}"
  end
end
