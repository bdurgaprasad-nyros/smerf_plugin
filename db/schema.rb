# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110617092416) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.boolean  "hide_label"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_value"
  end

  create_table "emps", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions_smerf_forms", :force => true do |t|
    t.integer "question_id",   :null => false
    t.integer "smerf_form_id", :null => false
    t.text    "responses",     :null => false
  end

  create_table "smerf_forms", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.string   "code",       :default => "", :null => false
    t.integer  "active",                     :null => false
    t.text     "cache"
    t.datetime "cache_date"
  end

  add_index "smerf_forms", ["code"], :name => "index_smerf_forms_on_code", :unique => true

  create_table "smerf_forms_users", :force => true do |t|
    t.integer "user_id",       :null => false
    t.integer "smerf_form_id", :null => false
    t.text    "responses",     :null => false
  end

  create_table "smerf_responses", :force => true do |t|
    t.integer "questions_smerf_form_id",                 :null => false
    t.string  "question_code",           :default => "", :null => false
    t.text    "response",                                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
