class CreateSeens < ActiveRecord::Migration
  def self.up
    create_table :seens do |t|
      t.string   :type, :default => "episode"

      t.integer  :episode_id
      t.integer  :movie_id
      t.integer  :phile_id
      t.string   :filename

      t.datetime :seen_at
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :seens, :episode_id
    add_index :seens, :phile_id
  end

  def self.down
    drop_table :seens
  end
end
