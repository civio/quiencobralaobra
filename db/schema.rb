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

ActiveRecord::Schema.define(version: 20160118174506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.datetime "publication_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_footer"
    t.string   "photo_credit"
    t.string   "photo_credit_link"
    t.text     "lead"
    t.integer  "author_id"
    t.boolean  "published",         default: false, null: false
    t.text     "content"
    t.text     "notes"
    t.string   "photo"
  end

  add_index "articles", ["slug"], name: "index_articles_on_slug", unique: true, using: :btree
  add_index "articles", ["title"], name: "index_articles_on_title", unique: true, using: :btree

  create_table "awards", force: :cascade do |t|
    t.integer  "public_body_id",           null: false
    t.integer  "bidder_id",                null: false
    t.date     "award_date"
    t.integer  "amount",         limit: 8
    t.hstore   "properties"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "category"
    t.string   "process_type"
    t.string   "process_track"
  end

  add_index "awards", ["bidder_id"], name: "index_awards_on_bidder_id", using: :btree
  add_index "awards", ["public_body_id"], name: "index_awards_on_public_body_id", using: :btree

  create_table "bidders", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "mentions", force: :cascade do |t|
    t.integer "article_id"
    t.integer "mentionee_id"
    t.string  "mentionee_type"
  end

  add_index "mentions", ["article_id"], name: "index_mentions_on_article_id", using: :btree
  add_index "mentions", ["mentionee_type", "mentionee_id"], name: "index_mentions_on_mentionee_type_and_mentionee_id", using: :btree

  create_table "public_bodies", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "public_bodies", ["name"], name: "index_public_bodies_on_name", unique: true, using: :btree
  add_index "public_bodies", ["slug"], name: "index_public_bodies_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name",                                null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
