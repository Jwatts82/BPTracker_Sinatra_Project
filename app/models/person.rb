class Person < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :readings, dependent: :destroy
  has_many :comments, through: :readings

end
