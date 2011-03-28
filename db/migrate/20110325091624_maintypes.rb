class Maintypes < ActiveRecord::Migration
  def self.up
    change_table :bettypes do |t|
      t.boolean :main, :default => false
    end
  end

  def self.down
    remove_column :bettypes, :main
  end
end
