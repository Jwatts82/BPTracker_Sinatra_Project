class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings do |t|
      t.integer :systolic
      t.integer :diastolic
      t.integer :pulse
      t.datetime :reading_date_time
      t.string :category
      t.references :person

      t.timestamps null: false
    end
  end
end
