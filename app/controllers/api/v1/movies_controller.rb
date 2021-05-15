class Api::V1::MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :update, :destroy]
  before_action :check_permission!

  # GET /api/v1/movies
  def index
    @movies = Movie.all

    render json: @movies
  end

  # GET /api/v1/movies/1
  def show
    render json: @movie
  end

  # POST /api/v1/movies
  def create
    @movie =Movie.new(movie_params)

    if @movie.save
      render json: @movie, status: :created
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/movies/1
  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/movies/1
  def destroy
    status, message = if @movie.shows.present?
                        [:unprocessable_entity, 'You can not delete a movie which has a show associated']
                      else
                        @movie.destroy
                        [:ok, 'Movie deleted']
                      end
    render json: { message: message }, status: status
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie =Movie.find_by(id: params[:id])
    check_for_instance(@movie, 'Movie', params[:id])
  end

  # Only allow a list of trusted parameters through.
  def movie_params
    params.permit(:title)
  end
end
