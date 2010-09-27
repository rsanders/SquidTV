class CreateIncomingPaths < ActiveRecord::Migration
  def self.up
    create_table :incoming_paths do |t|
      t.string   "source_type",        :default => "torrent"
      t.text     "path",                                        :null => false
      t.boolean  "active",      :default => true
      t.datetime "scanned_at"
      t.integer  "scan_period", :default => 300
      t.datetime "locked_at"
      t.string   "locked_by"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "contains_episodes", :default => true
      t.boolean  "contains_movies", :default => true
      t.boolean  "contains_music", :default => false
      t.boolean  "local",       :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :incoming_paths
  end
end
