class AddSeatNameToScreenSeats < ActiveRecord::Migration[6.1]
  def change
    add_column :screen_seats, :seat_number, :string, null: false
  end
end
