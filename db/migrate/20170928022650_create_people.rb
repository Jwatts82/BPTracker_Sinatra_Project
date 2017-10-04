class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.text :dob
      t.integer :age

      t.timestamps null: false
    end
  end
end
