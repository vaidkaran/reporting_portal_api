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

ActiveRecord::Schema.define(version: 20170629185420) do

  create_table "junit_test_cases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "junit_test_suite_id"
    t.string   "name"
    t.integer  "assertions"
    t.string   "classname"
    t.string   "status"
    t.integer  "time"
    t.integer  "skipped"
    t.string   "error_message"
    t.string   "error_type"
    t.text     "error_text",          limit: 65535
    t.string   "failure_message"
    t.string   "failure_type"
    t.text     "failure_text",        limit: 65535
    t.text     "system_out",          limit: 65535
    t.text     "system_err",          limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "junit_test_suite_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "report_id"
    t.string   "name"
    t.integer  "_errors"
    t.integer  "tests"
    t.integer  "failures"
    t.integer  "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "junit_test_suite_properties", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "junit_test_suite_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "junit_test_suites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "junit_test_suite_group_id"
    t.string   "name"
    t.integer  "tests"
    t.integer  "disabled"
    t.integer  "_errors"
    t.integer  "failures"
    t.string   "hostname"
    t.integer  "testsuiteid"
    t.string   "package"
    t.integer  "skipped"
    t.integer  "time"
    t.string   "timestamp"
    t.text     "system_out",                limit: 65535
    t.text     "system_err",                limit: 65535
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "mocha_failures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "report_id"
    t.text     "title",      limit: 65535
    t.text     "fullTitle",  limit: 65535
    t.integer  "duration"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "mocha_passes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "report_id"
    t.text     "title",      limit: 65535
    t.text     "fullTitle",  limit: 65535
    t.integer  "duration"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "mocha_stats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "report_id"
    t.integer  "suites"
    t.integer  "tests"
    t.integer  "passes"
    t.integer  "failures"
    t.string   "start"
    t.string   "end"
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mocha_tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "report_id"
    t.text     "title",      limit: 65535
    t.text     "fullTitle",  limit: 65535
    t.integer  "duration"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "org_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "provider",                             default: "email", null: false
    t.string   "uid",                                  default: "",      null: false
    t.string   "encrypted_password",                   default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "organisation_id"
    t.boolean  "admin",                                default: false
    t.index ["confirmation_token"], name: "index_org_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_org_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_org_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_org_users_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "organisational_users_projects", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "organisational_user_id", null: false
    t.integer "project_id",             null: false
  end

  create_table "organisations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "organisation_id"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "test_category_id"
    t.string   "_type"
    t.string   "format"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "test_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "provider",                             default: "email", null: false
    t.string   "uid",                                  default: "",      null: false
    t.string   "encrypted_password",                   default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens",                 limit: 65535
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.boolean  "superadmin",                           default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

end
