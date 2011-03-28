# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110328125506) do

  create_table "bettypes", :force => true do |t|
    t.string   "name"
    t.integer  "bookmaker_id"
    t.integer  "maintype_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "main",         :default => false
  end

  create_table "bookie_games", :force => true do |t|
    t.integer  "bookmaker_id"
    t.integer  "game_id"
    t.integer  "home_id"
    t.integer  "away_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starttime"
  end

  create_table "bookmakers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "home_id"
    t.integer  "away_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starttime"
  end

  create_table "odds", :force => true do |t|
    t.integer  "bookie_game_id"
    t.integer  "bettype_id"
    t.decimal  "odd1"
    t.decimal  "oddX"
    t.decimal  "odd2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teamnames", :force => true do |t|
    t.string   "name"
    t.integer  "bookmaker_id"
    t.integer  "mainname_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "main",         :default => false
  end

end
