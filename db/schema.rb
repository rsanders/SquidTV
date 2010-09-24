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

ActiveRecord::Schema.define(:version => 20100923230837) do

  create_table "episodes", :force => true do |t|
    t.integer  "phile_id"
    t.integer  "show_id"
    t.string   "season"
    t.integer  "episode"
    t.string   "title"
    t.datetime "aired_at"
    t.datetime "deleted_at"
    t.datetime "seen_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episodes", ["phile_id"], :name => "index_episodes_on_phile_id"
  add_index "episodes", ["show_id", "season", "episode"], :name => "index_episodes_on_show_id_and_season_and_episode"

  create_table "media_roots", :force => true do |t|
    t.string   "type",        :default => "EpisodeMediaRoot"
    t.text     "path",                                        :null => false
    t.boolean  "active",      :default => true
    t.datetime "scanned_at"
    t.integer  "scan_period", :default => 300
    t.datetime "locked_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_roots", ["path"], :name => "index_media_roots_on_path", :unique => true

  create_table "movies", :force => true do |t|
    t.integer  "phile_id"
    t.string   "name"
    t.datetime "first_aired_at"
    t.string   "url"
    t.datetime "seen_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movies", ["phile_id"], :name => "index_movies_on_phile_id"

  create_table "philes", :force => true do |t|
    t.string   "type",             :default => "EpisodePhile"
    t.integer  "media_root_id"
    t.text     "path",             :default => "f"
    t.string   "filename",         :default => "f"
    t.string   "format"
    t.integer  "quality"
    t.boolean  "hdtv"
    t.integer  "size"
    t.float    "length"
    t.datetime "file_created_at"
    t.datetime "file_modified_at"
    t.datetime "file_accessed_at"
    t.datetime "processed_at"
    t.datetime "seen_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "philes", ["file_modified_at", "deleted_at", "seen_at"], :name => "index_philes_on_file_modified_at_and_deleted_at_and_seen_at"
  add_index "philes", ["filename"], :name => "index_philes_on_filename"
  add_index "philes", ["path"], :name => "index_philes_on_path", :unique => true

  create_table "seens", :force => true do |t|
    t.string   "object_type", :default => "episode"
    t.integer  "episode_id"
    t.integer  "movie_id"
    t.integer  "phile_id"
    t.string   "filename"
    t.datetime "seen_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seens", ["episode_id"], :name => "index_seens_on_episode_id"
  add_index "seens", ["phile_id"], :name => "index_seens_on_phile_id"

  create_table "shows", :force => true do |t|
    t.string   "name"
    t.datetime "first_aired_at"
    t.datetime "ended_at"
    t.integer  "season_count"
    t.integer  "episode_count"
    t.text     "show_path"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
