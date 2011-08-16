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

ActiveRecord::Schema.define(:version => 20110816213252) do

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

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
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
    t.boolean  "locked",        :default => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "short"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.decimal  "rating_average",      :precision => 6, :scale => 2, :default => 0.0
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "season_id"
    t.integer  "playoff_id"
    t.integer  "weeks_id"
    t.datetime "scheduled_at"
    t.integer  "best_of"
    t.integer  "results"
    t.string   "url"
    t.string   "caster_ids"
    t.boolean  "live"
  end

  create_table "moderations", :force => true do |t|
    t.integer  "user_id"
    t.string   "mod_type"
    t.integer  "length"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "moderator_id"
    t.integer  "comment_id"
    t.datetime "ends_at"
  end

  create_table "newsletters", :force => true do |t|
    t.string   "subject_line"
    t.text     "body"
    t.boolean  "sent"
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

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.boolean  "published"
    t.integer  "playoff_teams"
  end

  create_table "seasons_maps", :id => false, :force => true do |t|
    t.integer "season_id"
    t.integer "map_id"
  end

  create_table "seasons_teams", :id => false, :force => true do |t|
    t.integer "season_id"
    t.integer "team_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

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
    t.string   "short_name"
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
    t.boolean  "caster"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.boolean  "photo_approved"
    t.integer  "roles_mask"
    t.boolean  "subscription"
  end

  create_table "vote_events", :force => true do |t|
    t.integer  "match_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "vote_event_id"
    t.integer  "player_id"
    t.integer  "user_id"
    t.integer  "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
