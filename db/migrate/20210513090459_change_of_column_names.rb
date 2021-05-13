class ChangeOfColumnNames < ActiveRecord::Migration[6.1]
  def change
    rename_column :screen_seats, :type, :seat_type
    remove_column :bookings, :no_f_seats
  end
end
