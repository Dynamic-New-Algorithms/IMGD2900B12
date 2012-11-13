# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121113204143) do

  create_table "asciiais", :force => true do |t|
    t.float    "ir_a"
    t.float    "ir_d"
    t.float    "ir_p"
    t.integer  "min_p"
    t.integer  "attack_timing"
    t.integer  "games_played"
    t.integer  "wins"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "ldhs", :force => true do |t|
    t.string   "name"
    t.integer  "points"
    t.integer  "difficulty"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
