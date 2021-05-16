# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Booking, type: :model do
  describe '#association' do
    it { should belong_to(:user) }
    it { should belong_to(:show) }
    it { should have_many(:show_seats).through(:show) }
  end
end
