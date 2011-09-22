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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110922191057) do

  create_table "accounts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_counter"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address_one"
    t.string   "address_two"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "web_address"
    t.string   "phone_number_office"
    t.string   "phone_number_fax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "orders", :force => true do |t|
    t.integer  "part_id"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price"
  end

  create_table "parts", :force => true do |t|
    t.string   "name"
    t.decimal  "cost"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_statuses", :force => true do |t|
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.string   "subject"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_status_id"
    t.integer  "requestor_id"
    t.integer  "solver_id"
    t.text     "solution"
    t.integer  "assignee_id"
    t.datetime "solved_at"
    t.integer  "account_id"
    t.integer  "company_id"
    t.integer  "number"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "username"
    t.string   "user_state"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer  "role_id"
    t.datetime "invitation_last_sent_at"
    t.string   "invitation_last_sent_to"
  end

end
