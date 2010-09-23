class CreatePhiles < ActiveRecord::Migration
  def self.up
    create_table :philes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :philes
  end
end
