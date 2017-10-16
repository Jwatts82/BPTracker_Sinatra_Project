class CreateCommentReadings < ActiveRecord::Migration
  def change
    create_table :comment_readings do |t|
      t.references :comment
      t.references :reading

      t.timestamps null: false
    end
  end
end
