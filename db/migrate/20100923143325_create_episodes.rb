class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.integer :phile_id

      t.integer :show_id
      t.string  :season
      t.integer :episode
      t.string  :title

      t.datetime :aired_at
      t.datetime :deleted_at
      t.datetime :seen_at

      t.timestamps
    end

    add_index :episodes, [:show_id, :season, :episode]
    add_index :episodes, :phile_id
  end

  def self.down
    drop_table :episodes
  end
end
