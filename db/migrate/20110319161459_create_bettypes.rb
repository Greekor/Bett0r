class CreateBettypes < ActiveRecord::Migration
  def self.up
    create_table :bettypes do |t|
      t.string :name
      t.references :bookmaker
      t.references :maintype

      t.timestamps
    end
  end

  def self.down
    drop_table :bettypes
  end
end
