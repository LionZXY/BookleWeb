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

ActiveRecord::Schema.define(version: 20160307200200) do

  create_table "auth", force: :cascade do |t|
    t.string  "auth_token", limit: 255
    t.string  "user_login", limit: 255
    t.integer "permission", limit: 4
  end

  create_table "books", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "annotation",        limit: 255
    t.string   "author",            limit: 255
    t.integer  "search_index",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at",                      null: false
    t.text     "table_of_contents", limit: 65535
    t.text     "other_text",        limit: 65535
  end

  create_table "usr", force: :cascade do |t|
    t.string  "login",    limit: 255
    t.string  "pswd_md5", limit: 255
    t.integer "perm",     limit: 4
  end

end
