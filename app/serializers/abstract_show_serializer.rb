# frozen_string_literal: true

class AbstractShowSerializer < ActiveModel::Serializer
  attributes :id, :timeslot, :details

  def details
    {
      screen: object.screen.name,
      movie: object.movie.title
    }
  end
end
