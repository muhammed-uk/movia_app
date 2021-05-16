class ShowSeat < ApplicationRecord
  belongs_to :screen_seat
  belongs_to :show

  validates_uniqueness_of :screen_seat_id, scope: :show_id

  def seat_number
    screen_seat.seat_number
  end
end
