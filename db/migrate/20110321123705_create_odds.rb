class CreateOdds < ActiveRecord::Migration
  def self.up
    create_table :odds do |t|
      t.references :bookie_game
      t.references :bettype
      t.decimal :odd1, :scale => 3
      t.decimal :oddX, :scale => 3
      t.decimal :odd2, :scale => 3

      t.timestamps
    end
  end

  def self.down
    drop_table :odds
  end
end
