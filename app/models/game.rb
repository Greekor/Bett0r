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
        unless (infos[:odd1].odd1.nil? || infos[:odd2].odd2.nil?) then
          infos[:per] = 1 / (1/infos[:odd1].odd1 + (infos[:oddX].oddX.nil? ? 0.0 : 1/infos[:oddX].oddX) + 1/infos[:odd2].odd2) * 100
          array << infos
        end
      end
    end
    array 
  end

  def self.best_bets_by_bookie(bookie)
    games = self.all
    array = []
    games.each do |game|
      game.odds.by_bettype.each do |bettype, odds|
        bookie_odds = odds.select { |o| o.bookie_game.bookmaker_id == bookie.id }.first
        if not bookie_odds.nil? then
          # bookie-odd is 1
          infos = {}
          infos[:game] = game
          infos[:bettype] = bettype
          
          infos[:odd1] = bookie_odds 
          odds.sort_by! { |o| o.oddX } 
          infos[:oddX] = odds.last
          odds.sort_by! { |o| o.odd2 }
          infos[:odd2] = odds.last
          unless (infos[:odd1].odd1.nil? || infos[:odd2].odd2.nil?) then
            infos[:per] = 1 / (1/infos[:odd1].odd1 + (infos[:oddX].oddX.nil? ? 0.0 : 1/infos[:oddX].oddX) + 1/infos[:odd2].odd2) * 100
            array << infos
          end

          # bookie-odd is X 
          unless bookie_odds.oddX.nil? then
            infos = {}
            infos[:game] = game
            infos[:bettype] = bettype
            odds.sort_by! { |o| o.odd1 }
            infos[:odd1] = odds.last
          
            infos[:oddX] = bookie_odds
            odds.sort_by! { |o| o.odd2 }
            infos[:odd2] = odds.last
            unless (infos[:odd1].odd1.nil? || infos[:odd2].odd2.nil?) then
              infos[:per] = 1 / (1/infos[:odd1].odd1 + (infos[:oddX].oddX.nil? ? 0.0 : 1/infos[:oddX].oddX) + 1/infos[:odd2].odd2) * 100
              array << infos
            end
          end

          # bookie-odd is 2 
          infos = {}
          infos[:game] = game
          infos[:bettype] = bettype
          odds.sort_by! { |o| o.odd1 }
          infos[:odd1] = odds.last
          odds.sort_by! { |o| o.oddX }
          infos[:oddX] = odds.last
          
          infos[:odd2] = bookie_odds
          unless (infos[:odd1].odd1.nil? || infos[:odd2].odd2.nil?) then
            infos[:per] = 1 / (1/infos[:odd1].odd1 + (infos[:oddX].oddX.nil? ? 0.0 : 1/infos[:oddX].oddX) + 1/infos[:odd2].odd2) * 100
            array << infos
          end

        end
      end
    end
    array 
  end
end
