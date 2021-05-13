class CreateScreenSeats < ActiveRecord::Migration[6.1]
  def change
    create_table :screen_seats do |t|
      t.references :screen, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
