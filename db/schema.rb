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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110708220900) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.text     "description"
    t.integer  "user_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.boolean  "featured"
    t.string   "featured_photo_file_name"
    t.string   "featured_photo_content_type"
    t.integer  "featured_photo_file_size"
    t.boolean  "published",                   :default => false, :null => false
  end

  create_table "attachments", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.binary   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "external_type"
    t.integer  "external_id"
    t.integer  "user_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "short"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "player0_id"
    t.integer  "player1_id"
    t.integer  "result"
    t.integer  "downloads"
    t.integer  "map_id"
    t.integer  "match_id"
    t.integer  "match_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "replay_file_name"
    t.string   "replay_content_type"
    t.integer  "replay_file_size"
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  create_table "matches", :force => true do |t|
    t.integer  "team0_id"
    t.integer  "team1_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "moderations", :force => true do |t|
    t.integer  "user_id"
    t.string   "mod_type"
    t.integer  "length"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comment_id"
    t.integer  "moderator_id"
  end

  create_table "partners", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.date     "date_joined"
    t.date     "date_quit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.boolean  "published"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.string   "website"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.text     "description"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.string   "login",                                  :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "active",              :default => false, :null => false
    t.datetime "last_updated"
    t.string   "first_name",                             :null => false
    t.string   "last_name",                              :null => false
    t.date     "birthdate"
    t.string   "race"
    t.text     "profile_text"
    t.string   "bnet_name"
    t.integer  "bent_code"
    t.integer  "bnet_id"
    t.text     "signature"
    t.integer  "country_id"
    t.integer  "permission_level"
    t.boolean  "caster"
    t.string   "team_name"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.boolean  "photo_approved"
  end

end
