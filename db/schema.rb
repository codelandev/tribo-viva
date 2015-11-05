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

ActiveRecord::Schema.define(version: 20151105164212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "bank_accounts", force: :cascade do |t|
    t.string   "cc",             default: "t", null: false
    t.string   "bank",           default: "t", null: false
    t.string   "agency",         default: "t", null: false
    t.string   "bank_number",    default: "t", null: false
    t.string   "operation_code", default: "t", null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "owner_name"
    t.string   "cnpj_cpf"
  end

  create_table "deliver_coordinators", force: :cascade do |t|
    t.string   "cpf",             default: "t", null: false
    t.string   "name",            default: "t", null: false
    t.string   "phone",           default: "t", null: false
    t.string   "email",           default: "t", null: false
    t.string   "avatar",          default: "t", null: false
    t.string   "address",         default: "t", null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "partial_address", default: "",  null: false
    t.string   "neighborhood",    default: "",  null: false
  end

  create_table "offer_items", force: :cascade do |t|
    t.integer  "offer_id"
    t.string   "name",                                default: ""
    t.string   "unit",                                default: "1", null: false
    t.integer  "quantity",                            default: 1,   null: false
    t.decimal  "unit_price", precision: 10, scale: 2, default: 0.0, null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "offer_items", ["offer_id"], name: "index_offer_items_on_offer_id", using: :btree

  create_table "offers", force: :cascade do |t|
    t.integer  "deliver_coordinator_id"
    t.integer  "bank_account_id"
    t.integer  "producer_id"
    t.text     "description",                                     default: "",  null: false
    t.string   "title",                                           default: "",  null: false
    t.string   "image",                                           default: "",  null: false
    t.decimal  "value",                  precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "operational_tax",        precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "coordinator_tax",        precision: 10, scale: 2, default: 0.0, null: false
    t.integer  "stock",                                           default: 0,   null: false
    t.datetime "collect_starts_at"
    t.datetime "collect_ends_at"
    t.datetime "offer_starts_at"
    t.datetime "offer_ends_at"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "offers", ["bank_account_id"], name: "index_offers_on_bank_account_id", using: :btree
  add_index "offers", ["deliver_coordinator_id"], name: "index_offers_on_deliver_coordinator_id", using: :btree
  add_index "offers", ["producer_id"], name: "index_offers_on_producer_id", using: :btree

  create_table "old_purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "offer_id"
    t.integer  "amount",         default: 0,         null: false
    t.string   "status",         default: "pending", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "transaction_id", default: "",        null: false
    t.string   "receipt"
  end

  add_index "old_purchases", ["offer_id"], name: "index_old_purchases_on_offer_id", using: :btree
  add_index "old_purchases", ["user_id"], name: "index_old_purchases_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "offer_id"
    t.integer  "purchase_id"
    t.integer  "quantity"
    t.decimal  "offer_value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "orders", ["offer_id"], name: "index_orders_on_offer_id", using: :btree
  add_index "orders", ["purchase_id"], name: "index_orders_on_purchase_id", using: :btree

  create_table "producers", force: :cascade do |t|
    t.text     "description",   default: "", null: false
    t.string   "name",          default: "", null: false
    t.string   "logo",          default: "", null: false
    t.string   "phone",         default: "", null: false
    t.string   "email",         default: "", null: false
    t.string   "address",       default: "", null: false
    t.string   "contact_name",  default: "", null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "certification"
    t.string   "video_url"
    t.string   "cover_image"
    t.string   "website"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status",                                  default: "pending", null: false
    t.decimal  "total",          precision: 10, scale: 2, default: 0.0,       null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "invoice_url"
    t.string   "invoice_pdf"
    t.string   "invoice_id"
    t.string   "payment_method"
    t.decimal  "taxes",          precision: 10, scale: 2, default: 0.0,       null: false
    t.string   "receipt",                                 default: "",        null: false
    t.string   "user_type"
  end

  add_index "purchases", ["user_id"], name: "index_purchases_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "cpf",                    default: "", null: false
    t.string   "name",                   default: "", null: false
    t.string   "email",                  default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "phone",                  default: "", null: false
    t.string   "address",                default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "offer_items", "offers"
  add_foreign_key "offers", "bank_accounts"
  add_foreign_key "offers", "deliver_coordinators"
  add_foreign_key "offers", "producers"
  add_foreign_key "old_purchases", "offers"
  add_foreign_key "old_purchases", "users"
  add_foreign_key "orders", "offers"
  add_foreign_key "orders", "purchases"
end
