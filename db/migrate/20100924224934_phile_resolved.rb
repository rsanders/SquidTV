class PhileResolved < ActiveRecord::Migration
  def self.up
    add_column :philes, :resolved, :boolean, :default => false
  end

  def self.down
    remove_column :philes, :resolved
  end
end
