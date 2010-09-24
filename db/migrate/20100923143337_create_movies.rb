class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.integer  :phile_id

      t.string   :name

      t.datetime :first_aired_at

      t.string   :url
      t.datetime :seen_at
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :movies, :phile_id
  end

  def self.down
    drop_table :movies
  end
end
