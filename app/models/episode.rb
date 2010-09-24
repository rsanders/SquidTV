class Episode < ActiveRecord::Base
  belongs_to :show
  belongs_to :phile
end
