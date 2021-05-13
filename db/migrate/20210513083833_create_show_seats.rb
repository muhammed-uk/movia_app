class CreateShowSeats < ActiveRecord::Migration[6.1]
  def change
    create_table :show_seats do |t|
      t.string :status
      t.integer :price
      t.references :screen_seat, null: false, foreign_key: true
      t.references :show, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
