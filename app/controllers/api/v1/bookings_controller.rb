class Api::V1::BookingsController < ApplicationController
  before_action :check_permission!, except: :create
  before_action :set_booking, only: [:show, :update, :destroy]
  around_action :wrap_in_transaction, only: :create

  # GET /api/v1/bookings
  def index
    @bookings = Play::QueryScope
      .new(Booking.all)
      .call(booking_query_params)

    render json: @bookings
  end

  # GET /api/v1/bookings/1
  def show
    render json: @booking
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
  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
    check_for_instance(@booking, 'Booking', params[:id])
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.permit(:show_id, seats: [])
  end

  def booking_query_params
    params.permit(:user_id, :show_id)
  end

  def setup_anonymous_user
    random_string = SecureRandom.alphanumeric
    @current_user = User.create!(
      name: "user-#{random_string}",
      email: "anonymous#{random_string}@gmail.com",
      password: random_string
    )
  end
end
