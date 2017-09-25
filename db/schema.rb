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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170925163852) do

  create_table "item_details", force: :cascade do |t|
    t.integer  "minweight"
    t.string   "weightin"
    t.integer  "item_id"
    t.integer  "rawMaterial_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "item_details", ["item_id"], name: "index_item_details_on_item_id"
  add_index "item_details", ["rawMaterial_id"], name: "index_item_details_on_rawMaterial_id"

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "Demand"
    t.integer  "MaxProduction",    default: -1
    t.integer  "today_production"
  end

  create_table "raw_materials", force: :cascade do |t|
    t.string   "name"
    t.integer  "quantity"
    t.string   "weightin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
