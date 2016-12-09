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

ActiveRecord::Schema.define(version: 20161208160544) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.datetime "start"
    t.datetime "end"
    t.string   "transport"
    t.string   "address"
    t.integer  "program_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "meetingtype_id"
    t.text     "notes"
    t.decimal  "event_hours",    precision: 10, scale: 2, default: "0.0"
    t.integer  "launch_break",                            default: 0
    t.date     "date_start"
    t.date     "date_end"
    t.index ["date_end"], name: "index_events_on_date_end", using: :btree
    t.index ["date_start"], name: "index_events_on_date_start", using: :btree
    t.index ["meetingtype_id"], name: "index_events_on_meetingtype_id", using: :btree
    t.index ["program_id"], name: "index_events_on_program_id", using: :btree
  end

  create_table "meetingtypes", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "color"
    t.integer  "is_paid"
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "buffer_time"
    t.string   "email_report"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "user_events", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.decimal  "hours",       precision: 12, scale: 2, default: "0.0"
    t.decimal  "earnings",    precision: 12, scale: 2, default: "0.0"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.decimal  "hourly_rate", precision: 12, scale: 2, default: "0.0"
    t.index ["event_id"], name: "index_user_events_on_event_id", using: :btree
    t.index ["user_id"], name: "index_user_events_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                           default: "",    null: false
    t.string   "encrypted_password",                              default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "dob"
    t.decimal  "hours",                  precision: 12, scale: 2, default: "0.0"
    t.decimal  "hourly_rate",            precision: 10, scale: 2, default: "0.0"
    t.decimal  "earnings",               precision: 12, scale: 2, default: "0.0"
    t.text     "notes"
    t.string   "client_id"
    t.boolean  "is_admin",                                        default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "events", "meetingtypes"
  add_foreign_key "events", "programs"
  add_foreign_key "user_events", "events"
  add_foreign_key "user_events", "users"
end
