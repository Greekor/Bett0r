class Mainnames < ActiveRecord::Migration
  def self.up
    change_table :teamnames do |t|
      t.boolean :main, :default => false
    end
  end

  def self.down
    remove_column :teamnames, :main
  end
end
