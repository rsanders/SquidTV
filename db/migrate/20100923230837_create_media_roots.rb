class CreateMediaRoots < ActiveRecord::Migration
  def self.up
    create_table :media_roots do |t|
      t.string   :type, :default => "EpisodeMediaRoot"
      t.text     :path, :null => false
      t.boolean  :active, :default => true

      t.datetime :scanned_at
      t.integer  :scan_period, :default => 300

      t.datetime :locked_at
      t.string   :locked_by

      t.timestamps
    end

    add_index :media_roots, :path, :unique => true
  end

  def self.down
    drop_table :media_roots
  end
end
