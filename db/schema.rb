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

ActiveRecord::Schema.define(version: 20190416131826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string   "number"
    t.text     "description",                                                             null: false
    t.integer  "user_id",                                                                 null: false
    t.integer  "wz_id"
    t.integer  "quantity",                                                                null: false
    t.decimal  "price",                 precision: 8, scale: 2
    t.datetime "delivery_request_date",                                                   null: false
    t.datetime "confirmation_date"
    t.datetime "invoice_date"
    t.datetime "delivery_date"
    t.string   "status",                                        default: "not_confirmed", null: false
    t.string   "type",                                                                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity_in_wz",                                default: 0
    t.boolean  "full_in_wz",                                    default: false
    t.datetime "deleted_at"
    t.string   "deleted_by"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "orders_wzs", force: :cascade do |t|
    t.integer "order_id",             null: false
    t.integer "wz_id",                null: false
    t.integer "quantity", default: 0
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "link"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                         null: false
    t.string   "last_name",                          null: false
    t.string   "email",                              null: false
    t.string   "encrypted_password",                 null: false
    t.integer  "sign_in_count",      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "admin",              default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "wzs", force: :cascade do |t|
    t.string   "number",      default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "status"
    t.string   "description"
  end

end
