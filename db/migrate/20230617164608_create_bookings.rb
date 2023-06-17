class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings, id: :uuid do |t|
      t.string :client_first_name, null: false
      t.string :client_last_name, null: false
      t.string :animal_name, null: false
      t.string :animal_type, null: false
      t.integer :service_length_hours, null: false
      t.date :service_date, null: false
      t.timestamps
    end
  end
end
