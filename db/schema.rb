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

ActiveRecord::Schema[8.0].define(version: 2025_02_07_205106) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "cep", null: false
    t.string "street"
    t.string "district"
    t.string "city"
    t.string "state"
    t.string "ddd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "search_count"
    t.string "lat"
    t.string "lng"
    t.index ["cep"], name: "index_addresses_on_cep", unique: true
  end
end
