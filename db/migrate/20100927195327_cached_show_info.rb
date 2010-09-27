class CachedShowInfo < ActiveRecord::Migration
  def self.up
    add_column :shows, :unwatched_episode_count, :integer, :default => 0
    add_column :shows, :latest_episode_at, :datetime
    add_column :shows, :latest_unwatched_episode_at, :datetime

    Show.reset_column_information

    begin
      Show.transaction do
        Show.all.map {|s| s.update_cached_values }
      end
    rescue Exception => e
      Rails.logger.error "Could not update show cached values: #{e.inspect}"
    end
  end

  def self.down
    remove_column :shows, :unwatched_episode_count
    remove_column :shows, :latest_episode_at
    remove_column :shows, :latest_unwatched_episode_at
  end
end
