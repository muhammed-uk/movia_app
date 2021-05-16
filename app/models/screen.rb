class Screen < ApplicationRecord
  has_many :screen_seats
  has_many :shows

  validates_presence_of :name
end
