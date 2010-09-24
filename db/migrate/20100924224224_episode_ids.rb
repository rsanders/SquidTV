class EpisodeIds < ActiveRecord::Migration
  def self.up
    add_column :episodes, :tvdb_id, :string
  end

  def self.down
    remove_column :episodes, :tvdb_id
  end
end
