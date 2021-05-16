# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Show, type: :model do
  describe '#validation' do
    subject { create(:show) }
    it {
      should validate_uniqueness_of(:timeslot)
        .scoped_to(:screen_id)
        .ignoring_case_sensitivity
    }
  end

  describe '#association' do
    it { should belong_to(:screen) }
    it { should belong_to(:movie) }
    it { should have_many(:show_seats) }
  end

  describe 'instance methods' do
    before(:all) do
      @show = create(:show)
      @screen_seats = @show.screen.screen_seats
    end

    context '.all_seats' do
      it 'should bring all the seats of the screen where this show occurs' do
        total_seats = @screen_seats.pluck(:seat_number)
        result = @show.all_seats.map(&:seat_number)
        expect(result).to match_array(total_seats)
      end
    end

    context '.all_seat_with_id_and_number' do
      it 'should bring all the seats of the screen where this show occurs' do
        total_seats = @screen_seats.pluck(:id, :seat_number)
        result = @show.all_seat_with_id_and_number
        expect(result).to match_array(total_seats)
      end
    end

    context '.all_seats_numbers' do
      it 'should bring all the seats of the screen where this show occurs' do
        total_seats = @screen_seats.pluck(:seat_number)
        result = @show.all_seats_numbers
        expect(result).to match_array(total_seats)
      end
    end

    context '.filled_seat_numbers' do
      context 'when no seats booked' do
        it 'should be empty' do
          result = @show.filled_seat_numbers
          expect(result).to be_empty
        end
      end

      context 'when there are seats booked' do
        before do
          @booking = create(:booking, show: @show, selected_seats: @screen_seats.limit(3))
        end

        it 'should should return the booked seats' do
          result = @show.filled_seat_numbers
          expect(result).to match_array(@screen_seats.limit(3).pluck(:seat_number))
        end
      end
    end
  end
end
