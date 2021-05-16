# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::ShowsController, type: :request, legacy: true do
  before(:all) do
    create_normal_user
    create_admin_user
    3.times { create(:movie) }
    @first_movie = Movie.first
    @screen_with_seats = create(:screen, :with_screen_seats)
    %w[12-3 4-7 8-11].each do |timeslot|
      create(:show, screen: @screen_with_seats, timeslot: timeslot, movie: @first_movie)
    end
    @show = @screen_with_seats.shows.first
    @selected_seats = @screen_with_seats.screen_seats.limit(3)
    @booking = create(:booking, show: @show, selected_seats: @selected_seats)
  end

  describe '# GET /api/v1/shows' do
    context 'user is' do
      context 'not logged in' do
        it 'should return unauthorized' do
          get api_v1_shows_path
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'normal user' do
        it 'should return unauthorized' do
          get api_v1_shows_path, params: {}, headers: @user_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'admin user' do
        it 'should be able to list all the shows' do
          get api_v1_shows_path, params: {}, headers: @admin_headers
          expect(response).to have_http_status(:ok)
          parsed_body = JSON.parse(response.body)
          expect(parsed_body.count).to eq(@screen_with_seats.shows.count)
          expected_result = Show.all.map do |show|
            {
              'id' => show.id,
              'timeslot' => show.timeslot,
              'details' => {
                'screen' => @screen_with_seats.name,
                'movie' => @first_movie.title
              }
            }
          end

          expect(parsed_body).to match_array(expected_result)
        end

        it 'should able to filter the result' do
          timeslot = '4-7'
          get api_v1_shows_path, params: { timeslot: timeslot }, headers: @admin_headers
          expect(response).to have_http_status(:ok)
          parsed_body = JSON.parse(response.body)
          expected_shows = @screen_with_seats.shows.where(timeslot: timeslot)
          expect(parsed_body.count).to eq(expected_shows.count)

          expected_result = expected_shows.map do |show|
            {
              'id' => show.id,
              'timeslot' => show.timeslot,
              'details' => {
                'screen' => @screen_with_seats.name,
                'movie' => @first_movie.title
              }
            }
          end

          expect(parsed_body).to match_array(expected_result)
        end
      end
    end
  end

  describe '# GET /api/v1/shows/:id' do
    context 'user is' do
      context 'not logged in' do
        it 'should return unauthorized' do
          get api_v1_show_path(@show)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'normal user' do
        it 'should return unauthorized' do
          get api_v1_show_path(@show), params: {}, headers: @user_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'admin user' do
        it 'should show the movie details' do
          get api_v1_show_path(@show), params: {}, headers: @admin_headers
          expect(response).to have_http_status(:ok)
          parsed_body = JSON.parse(response.body)

          expect(parsed_body['seat_details']['booked_seats'])
            .to match_array(@selected_seats.pluck(:seat_number))
          expect(parsed_body['seat_details']['total_seats']).to eq(@screen_with_seats.total_seats.to_i)
          expect(parsed_body['seat_details']['total_booked_seats']).to eq(@selected_seats.count)
          expect(parsed_body['seat_details']['total_vacant_seats'])
            .to eq(@screen_with_seats.total_seats.to_i - @selected_seats.count)
        end
      end
    end
  end
end
