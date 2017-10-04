class Comment < ActiveRecord::Base
  has_many :comment_readings, dependent: :destroy
  has_many :readings, through: :comment_readings
end
