class Starttime < ActiveRecord::Migration
  def self.up
    change_table :bookie_games do |t|
      t.datetime :starttime
    end
    change_table :games do |t|
      t.datetime :starttime
    end
  end

  def self.down
    remove_column :bookie_games, :starttime
    remove_column :games, :starttime
  end
end
