class PhileDevice < ActiveRecord::Migration
  def self.up
    add_column :philes, :device, :string
  end

  def self.down
    remove_column :philes, :device, :string
  end
end
