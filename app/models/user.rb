class User < ApplicationRecord
  has_many :bookings

  enum user_type: {
    admin: 'admin',
    user: 'user'
  }
end
