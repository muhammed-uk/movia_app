class BookingSerializer < ActiveModel::Serializer
  attributes :id, :booking_date, :show_details, :total_price
  belongs_to :user
  attr_accessor :total_booking_price

  def booking_date
    object.created_at.strftime('%d-%b-%Y : %I:%M %p')
  end

  def seats_booked
    @total_booking_price = 0
    object.show_seats.map do |show_seat|
      seat_price = show_seat.screen_seat.price
      @total_booking_price += seat_price
      show_seat.screen_seat.seat_number
    end
  end

  def total_price
    total_booking_price
  end

  def show_details
    {
      show_id: object.show.id,
      screen: object.show.screen.name,
      movie: object.show.movie.title,
      booked_seats: seats_booked,
    }
  end
end
