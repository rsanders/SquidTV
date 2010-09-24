class EpisodeRenaming < ActiveRecord::Migration
  def self.up
    rename_column :episodes, :episode, :number
    add_column :episodes, :unique_number, :string
  end

  def self.down
    rename_column :episodes, :number, :episodes
    remove_column :episodes, :unique_number, :string
  end
end
