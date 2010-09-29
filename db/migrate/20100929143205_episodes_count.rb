class EpisodesCount < ActiveRecord::Migration
  def self.up
    rename_column :shows, :episode_count, :episodes_count
  end

  def self.down
    rename_column :shows, :episodes_count, :episode_count
  end
end
