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

ActiveRecord::Schema.define(version: 20160313171529) do

  create_table "auth_tokens", force: :cascade do |t|
    t.string   "auth_token", limit: 255
    t.integer  "perm",       limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "typeToken",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_req"
  end

  create_table "books", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "annotation",        limit: 255
    t.string   "author",            limit: 255
    t.text     "other_text",        limit: 65535
    t.text     "table_of_contents", limit: 65535
    t.integer  "search_index",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_add",          limit: 4
  end

  add_index "books", ["search_index"], name: "index_books_on_search_index", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",      limit: 255
    t.string   "pswd",       limit: 255
    t.integer  "perm",       limit: 4
    t.integer  "ip",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
