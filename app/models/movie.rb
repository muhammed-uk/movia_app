class Movie < ApplicationRecord
  has_many :shows
  validates_presence_of :title
end
