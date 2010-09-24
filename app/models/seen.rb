class Seen < ActiveRecord::Base
  belongs_to :episode
  belongs_to :movie
  belongs_to :phile
end
