class RecordInum < ActiveRecord::Migration
  def self.up
    add_column :philes, :inum, :integer
    add_index  :philes, :inum

    add_column :media_roots, :local, :boolean, :default => true
  end

  def self.down
    remove_column :media_roots, :local

    remove_index :philes, :inum
    remove_column :philes, :inum
  end
end
