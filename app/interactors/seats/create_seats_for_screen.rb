# frozen_string_literal: true

module Seats
  class CreateSeatsForScreen
    include Interactor

    delegate :screen, to: :context

    def call
      create_seats
    end

    private

    def create_seats; end
  end
end
