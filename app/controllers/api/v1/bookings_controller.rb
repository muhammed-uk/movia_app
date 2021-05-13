class Api::V1::BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]
  around_action :wrap_in_transaction, only: :create

  # GET /api/v1/bookings
  def index
    @booking = Booking.all

    render json: @booking
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

  # PATCH/PUT /api/v1/bookings/1
  def update
    if @booking.update(booking_params)
      render json: @booking
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/bookings/1
  def destroy
    @booking.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.permit(:show_id, seats: [])
  end

  def setup_anonymous_user
    @current_user = User.create!(
      name: "anonymous-user-#{request.uuid}",
      email: "anonymous#{request.uuid}@gmail.com",
      password: 'anonymous_password'
    )
  end
end
