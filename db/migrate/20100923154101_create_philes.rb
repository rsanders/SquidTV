class CreatePhiles < ActiveRecord::Migration
  def self.up
    create_table :philes do |t|

      t.string  :type, :default => "episode"

      t.integer    :media_root_id
      t.text       :path, :default => false
      t.string     :filename, :default => false

      t.string  :format

      t.integer :quality
      t.boolean :hdtv
      t.integer :size
      t.float   :length

      t.datetime :file_created_at
      t.datetime :file_modified_at
      t.datetime :file_accessed_at

      t.datetime :seen_at
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :philes, :path
    add_index :philes, :filename
  end

  def self.down
    drop_table :philes
  end
end
