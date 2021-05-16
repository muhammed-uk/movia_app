# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  describe '#validation' do
    it do
      should define_enum_for(:user_type)
        .with_values(
          admin: 'admin',
          user: 'user'
        )
        .backed_by_column_of_type(:string)
    end
  end

  describe '#association' do
    it { should have_many(:bookings) }
  end
end
