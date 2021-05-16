# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Movie, type: :model do
  describe '#validation' do
    it { should validate_presence_of :title }
  end

  describe '#association' do
    it { should have_many(:shows) }
  end
end
