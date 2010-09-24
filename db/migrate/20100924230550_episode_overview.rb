class EpisodeOverview < ActiveRecord::Migration
  def self.up
    add_column :episodes, :overview, :text
  end

  def self.down
    remove_column :episodes, :overview
  end
end
