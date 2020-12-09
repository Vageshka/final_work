# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_08_134152) do

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.text "vacancy"
    t.text "requirements"
    t.text "conditions"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "offers", force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "company_id", null: false
    t.boolean "comp_agree", default: false
    t.boolean "stud_agree", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_offers_on_company_id"
    t.index ["student_id"], name: "index_offers_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "fullname"
    t.string "departament"
    t.string "group"
    t.string "wish"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "login"
    t.string "password_digest"
    t.boolean "company"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "companies", "users"
  add_foreign_key "offers", "companies"
  add_foreign_key "offers", "students"
  add_foreign_key "students", "users"
end
