class Screen < ApplicationRecord
  has_many :screen_seats
  has_many :shows
end
