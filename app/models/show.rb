class Show < ActiveRecord::Base
  has_many :episodes, :dependent => :destroy
end
