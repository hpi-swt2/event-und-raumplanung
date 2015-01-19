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

ActiveRecord::Schema.define(version: 20150119124943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "username"
    t.string   "action"
    t.string   "controller"
    t.text     "task_info"
    t.text     "changed_fields"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

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

  create_table "comments", force: true do |t|
    t.string   "author"
    t.string   "content"
    t.time     "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.string   "user_id"
  end

  create_table "equipment", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  add_index "equipment", ["room_id"], name: "index_equipment_on_room_id", using: :btree

  create_table "event_occurrences", force: true do |t|
    t.integer  "event_id"
    t.datetime "starts_occurring_at"
    t.datetime "ends_occurring_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_occurrences", ["event_id"], name: "index_event_occurrences_on_event_id", using: :btree

  create_table "event_templates", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "participant_count"
  end

  add_index "event_templates", ["user_id"], name: "index_event_templates_on_user_id", using: :btree

  create_table "event_templates_rooms", force: true do |t|
    t.integer "event_template_id"
    t.integer "room_id"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "participant_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "room_id"
    t.boolean  "is_private",        default: true
    t.string   "status",            default: "pending"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.date     "start_date"
    t.time     "start_time"
    t.date     "end_date"
    t.time     "end_time"
    t.boolean  "is_important"
    t.text     "schedule"
    t.integer  "event_id"
  end

  add_index "events", ["event_id"], name: "index_events_on_event_id", using: :btree
  add_index "events", ["room_id"], name: "index_events_on_room_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "events_rooms", force: true do |t|
    t.integer "event_id"
    t.integer "room_id"
  end

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "is_favorite"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["event_id"], name: "index_favorites_on_event_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "isLeader",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "room_id"
    t.integer  "permitted_entity_id"
    t.string   "permitted_entity_type"
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["permitted_entity_id", "permitted_entity_type"], name: "index_permissions_on_permitted_entity", using: :btree
  add_index "permissions", ["room_id"], name: "index_permissions_on_room_id", using: :btree

  create_table "room_properties", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "room_id"
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
    t.boolean  "done",              default: false
    t.string   "status"
    t.datetime "deadline"
    t.integer  "task_order"
    t.integer  "event_template_id"
    t.integer  "identity_id"
    t.string   "identity_type"
  end

  add_index "tasks", ["event_id"], name: "index_tasks_on_event_id", using: :btree
  add_index "tasks", ["event_template_id"], name: "index_tasks_on_event_template_id", using: :btree
  add_index "tasks", ["identity_id", "identity_type"], name: "index_tasks_on_identity_id_and_identity_type", using: :btree

  create_table "uploads", force: true do |t|
    t.integer  "task_id"
    t.string   "task_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                     null: false
    t.string   "username",               default: ""
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "status"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "identity_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "student"
    t.string   "fullname",               default: ""
    t.string   "office_location",        default: ""
    t.string   "office_phone",           default: ""
    t.string   "mobile_phone",           default: ""
    t.string   "language",               default: "German"
    t.boolean  "email_notification",     default: true
    t.boolean  "firstlogin",             default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
