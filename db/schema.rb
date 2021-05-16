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

ActiveRecord::Schema.define(version: 2021_05_16_143227) do

  create_table "bookings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "show_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["show_id"], name: "index_bookings_on_show_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "screen_seats", force: :cascade do |t|
    t.integer "screen_id", null: false
    t.string "seat_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "seat_number", null: false
    t.integer "price", default: 150
    t.index ["screen_id"], name: "index_screen_seats_on_screen_id"
  end

  create_table "screens", force: :cascade do |t|
    t.string "name"
    t.string "total_seats"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "show_seats", force: :cascade do |t|
    t.string "status"
    t.integer "screen_seat_id", null: false
    t.integer "show_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["screen_seat_id"], name: "index_show_seats_on_screen_seat_id"
    t.index ["show_id"], name: "index_show_seats_on_show_id"
  end

  create_table "shows", force: :cascade do |t|
    t.string "date"
    t.string "timeslot"
    t.integer "screen_id", null: false
    t.integer "movie_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["movie_id"], name: "index_shows_on_movie_id"
    t.index ["screen_id"], name: "index_shows_on_screen_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_type", default: "user"
  end

  add_foreign_key "bookings", "shows"
  add_foreign_key "bookings", "users"
  add_foreign_key "screen_seats", "screens"
  add_foreign_key "show_seats", "screen_seats"
  add_foreign_key "show_seats", "shows"
  add_foreign_key "shows", "movies"
  add_foreign_key "shows", "screens"
end
