class ScreenSeat < ApplicationRecord
  belongs_to :screen
  validates_uniqueness_of :seat_number , scope: :screen_id
end
