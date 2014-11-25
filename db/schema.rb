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

ActiveRecord::Schema.define(version: 20141124150448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["task_id"], name: "index_attachments_on_task_id", using: :btree

  create_table "bookings", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "start"
    t.datetime "end"
    t.integer  "event_id"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookings", ["event_id"], name: "index_bookings_on_event_id", using: :btree
  add_index "bookings", ["room_id"], name: "index_bookings_on_room_id", using: :btree

  create_table "equipment", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  add_index "equipment", ["room_id"], name: "index_equipment_on_room_id", using: :btree

  create_table "event_templates", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "room_id"
  end

  add_index "event_templates", ["room_id"], name: "index_event_templates_on_room_id", using: :btree
  add_index "event_templates", ["user_id"], name: "index_event_templates_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "participant_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "room_id"
    t.boolean  "is_private"
    t.string   "status",            default: "In Bearbeitung"
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  add_index "events", ["room_id"], name: "index_events_on_room_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "events_rooms", force: true do |t|
    t.integer "event_id"
    t.integer "room_id"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room_properties", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room_properties_rooms", force: true do |t|
    t.integer "room_property_id"
    t.integer "room_id"
  end

  create_table "rooms", force: true do |t|
    t.string   "name"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  add_index "rooms", ["group_id"], name: "index_rooms_on_group_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "done",        default: false
    t.integer  "user_id"
    t.string   "status"
  end

  add_index "tasks", ["event_id"], name: "index_tasks_on_event_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "identity_url",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["identity_url"], name: "index_users_on_identity_url", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
