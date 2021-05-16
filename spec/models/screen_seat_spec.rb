# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe ScreenSeat, type: :model do
  describe '#validation' do
    subject { create(:screen_seat) }
    it { should validate_presence_of :seat_number }
    it { should validate_presence_of :price }
    it { should validate_uniqueness_of(:seat_number).scoped_to(:screen_id) }
  end

  describe '#association' do
    it { should belong_to(:screen) }
  end
end
