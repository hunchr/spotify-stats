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

ActiveRecord::Schema[8.0].define(version: 2025_06_01_000000) do
  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_artists_on_name"
  end

  create_table "plays", force: :cascade do |t|
    t.integer "ms_played", null: false
    t.integer "song_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.index ["created_at"], name: "index_plays_on_created_at"
    t.index ["song_id"], name: "index_plays_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "artist_id", null: false
    t.index ["artist_id"], name: "index_songs_on_artist_id"
    t.index ["name"], name: "index_songs_on_name"
    t.index ["slug"], name: "index_songs_on_slug"
  end

  add_foreign_key "plays", "songs"
  add_foreign_key "songs", "artists"
end
