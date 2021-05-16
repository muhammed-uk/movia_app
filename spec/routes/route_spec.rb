require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Routes', type: :routing do
  describe 'api' do
    describe 'v1' do
      context 'movies' do
        it 'GET /api/v1/movies' do
          expect(get(api_v1_movies_path))
            .to route_to('api/v1/movies#index')
        end

        it 'GET /api/v1/movies/:id' do
          expect(get(api_v1_movie_path(1)))
            .to route_to('api/v1/movies#show', id: '1')
        end

        it 'POST /api/v1/movies/' do
          expect(post(api_v1_movies_path))
            .to route_to('api/v1/movies#create')
        end

        it 'PUT /api/v1/movies/:id' do
          expect(put(api_v1_movie_path(1)))
            .to route_to('api/v1/movies#update', id: '1')
        end

        it 'PUT /api/v1/movies/:id' do
          expect(delete(api_v1_movie_path(1)))
            .to route_to('api/v1/movies#destroy', id: '1')
        end
      end

      context 'shows' do
        it 'GET /api/v1/shows' do
          expect(get(api_v1_shows_path))
            .to route_to('api/v1/shows#index')
        end

        it 'GET /api/v1/shows/:id' do
          expect(get(api_v1_show_path(1)))
            .to route_to('api/v1/shows#show', id: '1')
        end
      end

      context 'bookings' do
        it 'GET /api/v1/bookings' do
          expect(get(api_v1_bookings_path))
            .to route_to('api/v1/bookings#index')
        end

        it 'POST /api/v1/bookings' do
          expect(post(api_v1_bookings_path))
            .to route_to('api/v1/bookings#create')
        end
      end

      context 'any other routes' do
        it 'should not be routable' do
          expect(get: '/api/v1/something-not-supported').not_to be_routable
        end
      end
    end
  end
end
