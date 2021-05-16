class Api::V1::ShowsController < ApplicationController
  before_action :set_show, only: [:show]
  before_action :check_permission!

  # GET /api/v1/shows
  def index
    @shows = Play::QueryScope
      .new(Show.all)
      .call(show_query_params)

    render json: @shows.includes(:screen, :movie),
           each_serializer: AbstractShowSerializer
  end

  # GET /api/v1/shows/1
  def show
    render json: @show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_show
    @show = Show.find_by(id: params[:id])
    check_for_instance(@movie, 'Show', params[:id])
  end

  def show_query_params
    params.permit(:date, :timeslot)
  end
end
