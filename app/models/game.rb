class Game < ActiveRecord::Base
  has_many :bookie_games, :dependent => :destroy
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

  def self.best_bets
    games = self.all
    array = []
    games.each do |game|
      game.odds.by_bettype.each do |bettype, odds|
        infos = {}
        infos[:game] = game
        infos[:bettype] = bettype
        odds.sort_by! { |o| o.odd1 }
        infos[:odd1] = odds.last
        odds.sort_by! { |o| o.oddX }
        infos[:oddX] = odds.last
        odds.sort_by! { |o| o.odd2 }
        infos[:odd2] = odds.last
        if not (infos[:odd1].odd1.nil? || infos[:odd2].odd2.nil?) then
          infos[:per] = 1 / (1/infos[:odd1].odd1 + (infos[:oddX].oddX.nil? ? 0.0 : 1/infos[:oddX].oddX) + 1/infos[:odd2].odd2) * 100
          array << infos
        end
      end
    end
    array 
  end
end
