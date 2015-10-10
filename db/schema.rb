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

ActiveRecord::Schema.define(version: 20151010185837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.datetime "publication_date"
  end

  add_index "articles", ["slug"], name: "index_articles_on_slug", unique: true, using: :btree
  add_index "articles", ["title"], name: "index_articles_on_title", unique: true, using: :btree

  create_table "awards", force: :cascade do |t|
    t.integer  "public_body_id", null: false
    t.integer  "bidder_id",      null: false
    t.date     "award_date"
    t.integer  "amount"
    t.hstore   "properties"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "awards", ["bidder_id"], name: "index_awards_on_bidder_id", using: :btree
  add_index "awards", ["properties"], name: "index_awards_on_properties", using: :btree
  add_index "awards", ["public_body_id"], name: "index_awards_on_public_body_id", using: :btree

  create_table "bidders", force: :cascade do |t|
    t.string "name"
    t.string "slug"
  end

  add_index "bidders", ["name"], name: "index_bidders_on_name", unique: true, using: :btree
  add_index "bidders", ["slug"], name: "index_bidders_on_slug", unique: true, using: :btree

  create_table "cpv_terms", force: :cascade do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "cpv_terms", ["code"], name: "index_cpv_terms_on_code", using: :btree

  create_table "public_bodies", force: :cascade do |t|
    t.string "name"
    t.string "slug"
  end

  add_index "public_bodies", ["name"], name: "index_public_bodies_on_name", unique: true, using: :btree
  add_index "public_bodies", ["slug"], name: "index_public_bodies_on_slug", unique: true, using: :btree

end
