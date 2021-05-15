# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::MoviesController, type: :request do
  before(:all) do
    create_normal_user
    create_admin_user
    5.times { create(:movie) }
  end

  describe '# GET /api/v1/movies' do
    context 'user is' do
      context 'not logged in' do
        it 'should return unauthorized' do
          get api_v1_movies_path
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'normal user' do
        it 'should return unauthorized' do
          get api_v1_movies_path, params: {}, headers: @user_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'admin user' do
        it 'should list movies' do
          get api_v1_movies_path, params: {}, headers: @admin_headers
          expect(response).to have_http_status(:ok)
          parsed_body = JSON.parse(response.body)
          expect(parsed_body.count).to eq(Movie.count)
          expect(parsed_body.map { |m| m['title'] }).to match_array(Movie.pluck(:title))
        end
      end
    end
  end

  describe '# GET /api/v1/movies/:id' do
    before(:all) { @movie = Movie.first }
    context 'user is' do
      context 'not logged in' do
        it 'should return unauthorized' do
          get api_v1_movie_path(@movie)
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'normal user' do
        it 'should return unauthorized' do
          get api_v1_movie_path(@movie), params: {}, headers: @user_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'admin user' do
        it 'should show the movie details' do
          get api_v1_movie_path(@movie), params: {}, headers: @admin_headers
          expect(response).to have_http_status(:ok)
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['title']).to eq(@movie.title)
        end
      end
    end
  end

  describe '# POST /api/v1/movies' do
    let(:valid_movie_param) { { title: Faker::Music.album } }

    context 'user is' do
      context 'not logged in' do
        it 'should return unauthorized' do
          post api_v1_movies_path, params: valid_movie_param
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'normal user' do
        it 'should return unauthorized' do
          post api_v1_movies_path, params: valid_movie_param, headers: @user_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'admin user' do
        context 'send invalid parameters' do
          it 'should show the error message' do
            post api_v1_movies_path, params: {}, headers: @admin_headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to eq({ 'title' => ["can't be blank"] })
          end
        end

        context 'send valid parameters' do
          it 'should create the movie record' do
            expect do
              post api_v1_movies_path,
                   params: valid_movie_param,
                   headers: @admin_headers
            end.to change(Movie, :count).by(1)

            expect(response).to have_http_status(:created)
          end
        end
      end
    end
  end

  describe '# PATCH/PUT /api/v1/movies/:id' do
    let(:valid_movie_param) { { title: 'New Title' } }
    before(:all) { @movie = Movie.last }

    context 'user is' do
      context 'not logged in' do
        it 'should return unauthorized' do
          put api_v1_movie_path(@movie), params: valid_movie_param
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'normal user' do
        it 'should return unauthorized' do
          put api_v1_movie_path(@movie), params: valid_movie_param, headers: @user_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'admin user' do
        context 'positive' do
          it 'should create the movie record' do
            put api_v1_movie_path(@movie),
                params: valid_movie_param,
                headers: @admin_headers

            expect(response).to have_http_status(:ok)
            expect(@movie.reload.title).to eq(valid_movie_param[:title])
          end
        end

        context 'negative' do
          it 'should create the movie record' do
            expect_any_instance_of(Movie).to receive(:update).and_return(false)
            put api_v1_movie_path(@movie),
                params: valid_movie_param,
                headers: @admin_headers

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end
