class ShowSerializer < ActiveModel::Serializer
  attributes :id, :seat_details

  def seat_details
    {
      booked_seats: booked_seats,
      available_seats: available_seats,
      total_seats: all_seats.size,
      total_booked_seats: booked_seats.size,
      total_vacant_seats: available_seats.size
    }
  end

  def booked_seats
    @_booked_seats ||= object.filled_seat_numbers
  end

  def all_seats
    @_all_seats ||= object.all_seats_numbers
  end

  def available_seats
    @_available_seats ||=  all_seats - booked_seats
  end
end
