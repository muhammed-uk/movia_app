# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::ShowsController, type: :request, legacy: true do
  before(:all) do
    generate_sample_data
    @first_movie = Movie.first
    @screen_with_seats = Screen.first
    @show = @screen_with_seats.shows.first
    @selected_seats = @screen_with_seats.screen_seats.limit(3)
    @booking = create_booking(@show, @selected_seats)
  end

  describe '# GET /api/v1/shows' do
    it 'should be able to list all the shows' do
      get api_v1_shows_path, params: {}
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
      get api_v1_shows_path, params: { timeslot: timeslot }
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

  describe '# GET /api/v1/shows/:id' do
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
