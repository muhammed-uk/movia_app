class RemoveBookingFromShowSeats < ActiveRecord::Migration[6.1]
  def change
    remove_column :show_seats, :booking_id
  end
end
