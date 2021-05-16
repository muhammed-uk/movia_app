class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :show
  has_many :show_seats, through: :show
end
