class Show < ApplicationRecord
  belongs_to :screen
  belongs_to :movie
  has_many :show_seats

  validates_uniqueness_of :timeslot, scope: :screen_id

  def all_seat_with_id_and_number
    screen
      .screen_seats
      .pluck(:id, :seat_number)
  end

  def filled_seat_numbers
    show_seats
      .includes(:screen_seat)
      .map(&:seat_number)
  end
end
