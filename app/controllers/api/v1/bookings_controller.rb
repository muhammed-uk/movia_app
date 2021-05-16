class Api::V1::BookingsController < ApplicationController
  before_action :check_permission!, except: :create
  around_action :wrap_in_transaction, only: :create

  # GET /api/v1/bookings
  def index
    @bookings = Play::QueryScope
                  .new(Booking.all)
                  .call(booking_query_params)

    render json: @bookings.includes(
      :user,
      show: %i[screen movie],
      show_seats: [:screen_seat]
    )
  end

  # POST /api/v1/bookings
  def create
    @current_user ||= setup_anonymous_user
    result = Play::BookTicket.call(
      params: booking_params,
      current_user: @current_user
    )

    if result.success?
      @save_to_cache = true
      render json: result.booking_summary, status: :created
    else
      render json: { error: result.errors }, status: :unprocessable_entity
      raise ActiveRecord::Rollback
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def booking_params
    params.permit(:show_id, seats: [])
  end

  def booking_query_params
    params.permit(:user_id, :show_id)
  end
end
