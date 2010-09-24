class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.string     :name

      t.datetime   :first_aired_at
      t.datetime   :ended_at

      t.integer    :season_count
      t.integer    :episode_count

      t.text       :show_path 

      t.string     :url

      t.timestamps
    end
  end

  def self.down
    drop_table :shows
  end
end
