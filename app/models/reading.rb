class Reading < ActiveRecord::Base
  belongs_to :person
  has_many :comment_readings, dependent: :destroy
  has_many :comments, through: :comment_readings

end
