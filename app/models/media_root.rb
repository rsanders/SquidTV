class MediaRoot < ActiveRecord::Base
  scope :active, :conditions => {:active => true} 
  scope :inactive, :conditions => {:active => false}

end
