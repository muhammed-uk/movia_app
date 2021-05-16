# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Api::V1::BookingsController, type: :request, legacy: true do
  before(:all) do
    generate_sample_data
    @screen = Screen.first
    @show = @screen.shows.first
  end

  describe '# POST /api/v1/bookings' do
    describe 'user is' do
      context 'not logged in' do
        before(:all) do
          @selected_seats = @screen.screen_seats.limit(3)
        end

        context 'passing invalid params' do
          it 'should return the errors when seat number are not passed' do
            post api_v1_bookings_path, params: { show_id: @show.id }
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)['error'])
              .to eq(['Seat numbers are mandatory, please pass in Array.'])
          end
        end

        context 'passing valid params' do
          context 'when something goes wrong in the process' do
            it 'should rollback everything safely' do
              previous_user_count = User.count
              previous_booking_count = Booking.count

              params = {
                show_id: @show.id,
                seats: @selected_seats.pluck(:seat_number)
              }

              # failing the process manually
              expect(ShowSeat).to receive(:insert_all!).and_raise(StandardError, 'Service unavailable')

              post api_v1_bookings_path, params: params
              expect(JSON.parse(response.body)['error'])
                .to eq(["Oops.. Something went wrong. \n Error: Service unavailable"])

              expect(User.count).to eq(previous_user_count)
              expect(Booking.count).to eq(previous_booking_count)
            end
          end

          context 'when everything goes well' do
            it 'should allow to book tickets creating a random user' do
              params = {
                show_id: @show.id,
                seats: @selected_seats.pluck(:seat_number)
              }

              expect { post api_v1_bookings_path, params: params }
                .to change(Booking, :count).by(1)
                                           .and change(ShowSeat, :count).by(3)
                                                                        .and change(User, :count).by(1)

              expect(response).to have_http_status(:created)
              parsed_response = JSON.parse(response.body)
              expect(parsed_response['message']).to eq('Congratulation!, Your booking is confirmed')
              expected_order_details = {
                'date' => Date.today.strftime('%Y-%m-%d'),
                'seats_booked' => params[:seats],
                'total_amount' => @selected_seats.pluck(:price).sum,
                'movie_name' => @show.movie.title,
                'time_slot' => @show.timeslot
              }
              expect(parsed_response['order_details']).to eq(expected_order_details)
            end
          end
        end
      end

      context 'logged in' do
        before(:all) do
          @selected_seat = @screen.screen_seats.last
        end

        context 'passing invalid params' do
          it 'should return the errors when show id is not passed' do
            post api_v1_bookings_path,
                 params: { seats: [@selected_seat.seat_number] },
                 headers: @user_headers
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)['error'])
              .to eq(['Could not find the show.'])
          end
        end

        context 'passing valid params' do
          it 'should allow to book tickets without creating a new user' do
            current_user_count = User.count
            params = {
              show_id: @show.id,
              seats: [@selected_seat.seat_number]
            }

            expect do
              post api_v1_bookings_path,
                   params: params,
                   headers: @user_headers
            end.to change(Booking, :count).by(1)
                                          .and change(ShowSeat, :count).by(1)

            expect(response).to have_http_status(:created)
            parsed_response = JSON.parse(response.body)
            expect(parsed_response['message']).to eq('Congratulation!, Your booking is confirmed')
            expected_order_details = {
              'date' => Date.today.strftime('%Y-%m-%d'),
              'seats_booked' => params[:seats],
              'total_amount' => @selected_seat.price,
              'movie_name' => @show.movie.title,
              'time_slot' => @show.timeslot
            }
            expect(parsed_response['order_details']).to eq(expected_order_details)
            expect(User.count).to eq(current_user_count)
          end
        end
      end
    end
  end

  describe '# GET /api/v1/bookings' do
    describe 'user is' do
      describe 'not logged in' do
        it 'should return unauthorized' do
          get api_v1_bookings_path
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'logged in' do
        it 'should return unauthorized' do
          get api_v1_bookings_path, params: {}, headers: @user_headers
          expect(response).to have_http_status(:unauthorized)
        end
      end

      describe 'admin' do
        context 'When no booking found' do
          it 'should return empty result' do
            get api_v1_bookings_path, params: {}, headers: @admin_headers
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to be_empty
          end
        end

        context 'When booking found' do
          before(:all) do
            @selected_seats = [@screen.screen_seats.last]
            @admin_user = User.admin.first
            create_booking(@show, @selected_seats, @admin_user)
          end

          it 'should return the result' do
            get api_v1_bookings_path, params: {}, headers: @admin_headers
            expect(response).to have_http_status(:ok)
            parsed_response = JSON.parse(response.body)
            expect(parsed_response.count).to eq(Booking.count)
            first_response = parsed_response.first

            expected_show_details = {
              'show_id' => @show.id,
              'screen' => @show.screen.name,
              'movie' => @show.movie.title,
              'booked_seats' => [
                @selected_seats.first.seat_number
              ]
            }
            expect(first_response['show_details']).to eq(expected_show_details)

            expected_total_price = @selected_seats.pluck(:price).sum
            expect(first_response['total_price']).to eq(expected_total_price)

            expected_user_details = {
              'name' => @admin_user.name,
              'email' => @admin_user.email
            }
            expect(first_response['user']).to eq(expected_user_details)
          end
        end
      end
    end
  end
end
