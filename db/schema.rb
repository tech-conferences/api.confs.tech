# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_06_29_230840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conferences", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "url"
    t.string "city"
    t.string "country"
    t.string "startDate"
    t.string "endDate"
    t.string "cfpStartDate"
    t.string "cfpEndDate"
    t.string "cfpUrl"
    t.string "twitter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "emails"
    t.integer "twitter_followers"
    t.datetime "tweeted_at"
    t.string "affiliateUrl"
    t.string "affiliateText"
    t.float "latitude"
    t.float "longitude"
    t.date "start_date"
    t.date "end_date"
    t.string "cocUrl"
    t.boolean "offersSignLanguageOrCC", default: false
    t.boolean "online", default: false
    t.string "locales"
    t.string "github"
    t.index ["uuid"], name: "index_conferences_on_uuid", unique: true
  end

  create_table "conferences_topics", id: false, force: :cascade do |t|
    t.integer "topic_id"
    t.integer "conference_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
