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

ActiveRecord::Schema.define(:version => 20130516160603) do

  create_table "earthquakes", :primary_key => "local_id", :force => true do |t|
    t.string   "id"
    t.float    "magnitude"
    t.string   "place"
    t.datetime "time"
    t.string   "url"
    t.string   "detail"
    t.string   "title"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "depth"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "earthquakes", ["id"], :name => "index_earthquakes_on_id", :unique => true
  add_index "earthquakes", ["latitude"], :name => "index_earthquakes_on_latitude"
  add_index "earthquakes", ["longitude"], :name => "index_earthquakes_on_longitude"
  add_index "earthquakes", ["magnitude"], :name => "index_earthquakes_on_magnitude"
  add_index "earthquakes", ["time"], :name => "index_earthquakes_on_time"

end
