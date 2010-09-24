class Episode < ActiveRecord::Base
  belongs_to :show
  belongs_to :phile

  validates_uniqueness_of :number, :scope => [:show_id, :season]
  validates_uniqueness_of :unique_number, :scope => [:show_id],
                          :allow_nil => true, :allow_blank => true
  

end
