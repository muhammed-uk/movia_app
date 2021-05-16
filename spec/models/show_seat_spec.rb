# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ShowSeat, type: :model do
  describe '#validation' do
    subject { create(:show_seat) }
    it { should validate_uniqueness_of(:screen_seat_id).scoped_to(:show_id) }
  end

  describe '#association' do
    it { should belong_to(:screen_seat) }
    it { should belong_to(:show) }
  end

  describe 'instance methods' do
    context '.seat_number' do
      it 'should bring the seat number associated' do
        show_seat = create(:show_seat)
        expect(show_seat.seat_number).to eq(show_seat.screen_seat.seat_number)
      end
    end
  end
end
