class ConfidenceAndCanon < ActiveRecord::Migration
  def self.up
    add_column :shows, :confidence, :float, :default => 0.5
    add_column :shows, :sortable_name, :string
    add_column :shows, :tvdb_id, :string

    add_index :shows, :sortable_name
    add_index :shows, :tvdb_id

    create_table :show_names do |t|
      t.integer   :show_id
      t.string    :name
      t.string    :soundex
      t.string    :process, :default => "exact"
      t.float     :confidence, :default => 0.5
    end

    add_index :show_names, :name, :unique => true
  end

  def self.down
    drop_table :show_names

    remove_index :shows, :sortable_name
    remove_index :shows, :tvdb_id

    remove_column :shows, :tvdb_id
    remove_column :shows, :sortable_name
    remove_column :shows, :confidence
  end
end
