class CreateBookieGames < ActiveRecord::Migration
  def self.up
    create_table :bookie_games do |t|
      t.references :bookmaker
      t.references :game
      t.references :home
      t.references :away

      t.timestamps
    end
  end

  def self.down
    drop_table :bookie_games
  end
end
