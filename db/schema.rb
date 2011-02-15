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

ActiveRecord::Schema.define(:version => 20110215170816) do

  create_table "changes", :force => true do |t|
    t.text     "intern_comments"
    t.text     "extern_comments"
    t.string   "change_type"
    t.integer  "responsible_id"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tickets", :force => true do |t|
    t.integer  "student_id",                                     :null => false
    t.string   "teacher"
    t.string   "course"
    t.integer  "responsible_id"
    t.string   "corresponding_to"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",            :limit => 50, :default => "", :null => false
  end

  create_table "users", :primary_key => "uid", :force => true do |t|
    t.string   "mail",         :null => false
    t.string   "name",         :null => false
    t.integer  "role_id",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ticket_taker"
  end

end
