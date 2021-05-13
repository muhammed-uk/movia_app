class ShowSeat < ApplicationRecord
  belongs_to :screen_seat
  belongs_to :show
  belongs_to :booking

  validates_uniqueness_of :screen_seat_id, scope: :show_id

  def seat_id_with_number
    screen_seat.pluck(:id, :seat_number)
  end

  def seat_number
    screen_seat.seat_number
  end
end
