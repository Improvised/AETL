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

ActiveRecord::Schema.define(version: 20100219202849) do

  create_table "carriers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_request_job_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_requests", force: true do |t|
    t.string   "cr_job_id"
    t.text     "project_note"
    t.text     "trans_desc"
    t.integer  "project_id"
    t.datetime "date_in"
    t.datetime "due_date"
    t.string   "project_name"
    t.string   "project_number"
    t.integer  "client_request_job_type_id"
    t.integer  "contact_id"
    t.integer  "job_status_id"
    t.integer  "billing_to_contact_id"
    t.integer  "billing_to_company_id"
    t.string   "purchase_order"
    t.integer  "invoice"
    t.string   "price"
    t.integer  "company_id"
    t.integer  "travel_id"
    t.integer  "handling_id"
    t.integer  "employee_production_id"
    t.integer  "production_hour"
    t.datetime "date_finished"
    t.integer  "account_manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference_ae_job_id"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone"
    t.string   "fax"
    t.integer  "billing_to_company_id"
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.string   "email"
    t.text     "ar_notes"
  end

  create_table "contacts", force: true do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "deliveries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_productions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_project_managers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "handlings", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobchecklists", force: true do |t|
    t.integer  "project_id"
    t.integer  "carrier_id"
    t.integer  "employee_project_manager_id"
    t.text     "job_description"
    t.integer  "number_of_copies"
    t.integer  "layout_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  create_table "layouts", force: true do |t|
    t.string   "name"
    t.boolean  "tabloid"
    t.boolean  "landscape"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "ae_job_id"
    t.string   "name"
    t.string   "number"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "company_id"
    t.integer  "contact_id"
    t.integer  "account_manager_id"
    t.date     "date_in"
    t.date     "due_date"
    t.integer  "job_status_id"
    t.integer  "employee_production_id"
    t.float    "production_hour"
    t.integer  "mileage"
    t.integer  "employee_project_manager_id"
    t.float    "project_manager_hour"
    t.integer  "job_type_id"
    t.integer  "handling_id"
    t.integer  "travel_id"
    t.integer  "billing_to_company_id"
    t.integer  "billing_to_contact_id"
    t.string   "billing_note"
    t.decimal  "price",                       precision: 12, scale: 2
    t.string   "invoice_number"
    t.text     "job_history"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delivery_id"
  end

  create_table "sales", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "travels", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "view_jobchecklists", force: true do |t|
    t.integer  "jobchecklist_id"
    t.string   "view"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.datetime "time_of_day_shot"
    t.string   "field_of_view",    limit: 5
  end

end
