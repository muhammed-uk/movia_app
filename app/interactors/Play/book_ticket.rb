module Play
  class BookTicket
    include Interactor
    include CacheHelper
    delegate :params, :current_user, :show,
             :cache_key, :seats_to_be_booked, :booking,
             to: :context

    def call
      set_instances
      perform_validation
      perform_booking
      setup_summary
    end

    private

    def set_instances
      context.cache_key = "Show:#{params['show_id']}"
      context.seats_to_be_booked = {}
    end

    def perform_validation
      check_showing
      check_seats
    end

    def check_showing
      show_id = params[:show_id]
      context.show = Show.find_by(id: show_id)
      fail_the_context("Could not find the show.") unless show
    end

    def check_seats
      seats_to_be_booked = params[:seats]
      fail_the_context('Seat numbers are mandatory, please pass in Array.') if
        seats_to_be_booked.blank? || !seats_to_be_booked.is_a?(Array)

      duplicate_entries = seats_to_be_booked
                            .group_by{ |element| element }
                            .select { |_, repeated_collection| repeated_collection.size > 1 }
                            .keys
      fail_the_context("#{duplicate_entries.join(', ')} is/are repeated.") if
        duplicate_entries.present?

      seat_id_number_mapping = read_or_write(cache_key,'seat_id_number_mapping', show)
      invalid_seat_numbers = seats_to_be_booked - seat_id_number_mapping.values
      fail_the_context("#{invalid_seat_numbers.join(', ')} is/are invalid.") if
        invalid_seat_numbers.present?

      occupied_seats = read_or_write(cache_key,'occupied_seats', show)
      requested_occupied_seats = occupied_seats & seats_to_be_booked
      fail_the_context("#{requested_occupied_seats.join(', ')} is/are already booked") if
        requested_occupied_seats.present?

      context.seats_to_be_booked = ScreenSeat.where(seat_number: seats_to_be_booked)
    end

    def perform_booking
      context.booking = Booking.create!(user: current_user, show: show)
      context.show_seats = show.show_seats.insert_all!(show_seat_params)
    rescue StandardError => error
      fail_the_context("Oops.. Something went wrong. \n Error: #{error.message}")
    end

    def setup_summary
      context.booking_summary = {
        message: "Congratulation!, Your booking is confirmed",
        order_details: {
          date: Date.today,
          seats_booked: params[:seats],
          total_amount: seats_to_be_booked.sum(:price),
          movie_name: show.movie.title,
          time_slot: show.timeslot
        }
      }
    end

    def fail_the_context(failure_reason)
      context.fail!(errors: [failure_reason])
    end

    def show_seat_params
      timestamp = Time.now
      seats_to_be_booked.map do |seat|
        {
          booking_id: booking.id,
          screen_seat_id: seat.id,
          created_at: timestamp,
          updated_at: timestamp
        }
      end
    end
  end
end