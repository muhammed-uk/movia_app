class ChangePrice < ActiveRecord::Migration[6.1]
  def change
    remove_column :show_seats, :price
    add_column :screen_seats, :price, :integer, default: 150
  end
end
