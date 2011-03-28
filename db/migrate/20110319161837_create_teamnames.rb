class CreateTeamnames < ActiveRecord::Migration
  def self.up
    create_table :teamnames do |t|
      t.string :name
      t.references :bookmaker
      t.references :mainname

      t.timestamps
    end
  end

  def self.down
    drop_table :teamnames
  end
end
