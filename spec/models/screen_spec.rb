# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Screen, type: :model do
  describe '#validation' do
    it { should validate_presence_of :name }
  end

  describe '#association' do
    it { should have_many(:shows) }
    it { should have_many(:screen_seats) }
  end
end
