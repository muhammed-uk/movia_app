# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

module Play
  RSpec.describe BookTicket do
    before(:all) do
      generate_sample_data
      @movie = Movie.first
      @screen = Screen.first
      @show = @screen.shows.first
      @selected_seats = @screen.screen_seats.limit(3)
      @booking = create_booking(@show, @selected_seats)
    end

    let(:try_to_book_the_ticket) do
      described_class.call(
        current_user: @user,
        params: @booking_params
      )
    end

    describe 'Ticket Booking' do
      describe 'negative scenarios' do
        context 'show_id' do
          context 'when show id is invalid' do
            it 'should return the error' do
              @booking_params = {
                show_id: 'some-invalid-id',
                seats: ['A-1']
              }
              result = try_to_book_the_ticket

              expect(result.success?).to eq(false)
              expect(result.errors).to eq(['Could not find the show.'])
            end
          end
        end

        context 'seats' do
          context 'when seat numbers are not provided' do
            it 'should return the error' do
              @booking_params = { show_id: Show.first.id }
              result = try_to_book_the_ticket

              expect(result.success?).to eq(false)
              expect(result.errors).to eq(['Seat numbers are mandatory, please pass in Array.'])
            end
          end

          context 'when seat numbers are provided' do
            context 'but not in array' do
              it 'should return the error' do
                @booking_params = { show_id: Show.first.id, seats: 'A-12' }
                result = try_to_book_the_ticket

                expect(result.success?).to eq(false)
                expect(result.errors).to eq(['Seat numbers are mandatory, please pass in Array.'])
              end
            end

            context 'but duplicates present' do
              it 'should return the error' do
                @booking_params = { show_id: Show.first.id, seats: %w[A-12 A-13 A-12] }
                result = try_to_book_the_ticket

                expect(result.success?).to eq(false)
                expect(result.errors).to eq(['A-12 is/are repeated.'])
              end
            end

            context 'but invalid seat ids' do
              it 'should return the error' do
                @booking_params = { show_id: Show.first.id, seats: %w[SEAT-1000] }
                result = try_to_book_the_ticket

                expect(result.success?).to eq(false)
                expect(result.errors).to eq(['SEAT-1000 is/are invalid.'])
              end
            end

            context 'but seats are already booked' do
              it 'should return the error' do
                booked_seats = @selected_seats.pluck(:seat_number)
                @booking_params = { show_id: Show.first.id, seats: booked_seats }
                result = try_to_book_the_ticket

                expect(result.success?).to eq(false)
                expect(result.errors).to eq(["#{booked_seats.join(', ')} is/are already booked"])
              end
            end
          end
        end

        context 'something goes wrong in the process of booking' do
          it 'should return the error rollback changes' do
            seat_to_book = @screen.screen_seats.last.seat_number
            @booking_params = { show_id: Show.first.id, seats: [seat_to_book] }

            # mocking the error
            expect(ShowSeat).to receive(:insert_all!)
              .and_raise(StandardError, 'Service unavailable')

            result = try_to_book_the_ticket

            expect(result.success?).to eq(false)
            expect(result.errors).to eq(["Oops.. Something went wrong. \n Error: Service unavailable"])
          end
        end
      end

      describe 'positive scenario' do
        it 'should book the ticket and return the summary' do
          selected_show = Show.first
          seats_to_book = @screen.screen_seats
                                 .order(created_at: :desc)
                                 .limit(2)
          @booking_params = { show_id: selected_show.id, seats: seats_to_book.pluck(:seat_number) }

          result = try_to_book_the_ticket
          expect(result.success?).to eq(true)
          expect(result.errors).to be_nil
          summary = result.booking_summary.deep_stringify_keys!

          expect(summary['message']).to eq('Congratulation!, Your booking is confirmed')
          expect(summary['order_details']['total_amount']).to eq(seats_to_book.pluck(:price).sum)
          expect(summary['order_details']['movie_name']).to eq(selected_show.movie.title)
          expect(summary['order_details']['time_slot']).to eq(selected_show.timeslot)
          expect(summary['order_details']['seats_booked']).to match_array(seats_to_book.pluck(:seat_number))
        end
      end
    end
  end
end
