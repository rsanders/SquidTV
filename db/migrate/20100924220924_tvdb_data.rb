class TvdbData < ActiveRecord::Migration
  def self.up
    add_column :shows, :runtime, :integer
    add_column :shows, :network, :string
    add_column :shows, :overview, :text
    add_column :shows, :genre, :string
  end

  def self.down
    remove_column :shows, :runtime
    remove_column :shows, :network
    remove_column :shows, :overview
    remove_column :shows, :genre
  end
end
