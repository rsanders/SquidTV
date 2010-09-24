class Episode < ActiveRecord::Base
  belongs_to :show
  belongs_to :phile

  validates_uniqueness_of :number, :scope => [:show_id, :season]
  validates_uniqueness_of :unique_number, :scope => [:show_id],
                          :allow_nil => true, :allow_blank => true
  

  def valid_numbers?
    ! (season.blank? || season.to_s == "0" || number.blank? || number.to_s == "0")
  end
end
