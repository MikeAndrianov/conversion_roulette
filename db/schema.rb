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

ActiveRecord::Schema.define(version: 20171014133703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "currency_rates", force: :cascade do |t|
    t.string "base", null: false
    t.date "date", null: false
    t.json "rates", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forecast_currency_rates", force: :cascade do |t|
    t.date "date"
    t.float "rate"
    t.bigint "forecast_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forecast_id"], name: "index_forecast_currency_rates_on_forecast_id"
  end

  create_table "forecasts", force: :cascade do |t|
    t.string "currency", null: false
    t.float "amount", null: false
    t.string "target_currency", null: false
    t.integer "max_waiting_time", null: false
    t.date "date_from", null: false
    t.date "date_to", null: false
    t.bigint "forecasts_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.index ["forecasts_id"], name: "index_forecasts_on_forecasts_id"
    t.index ["user_id"], name: "index_forecasts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "forecast_currency_rates", "forecasts"
  add_foreign_key "forecasts", "forecasts", column: "forecasts_id"
  add_foreign_key "forecasts", "users"
end
