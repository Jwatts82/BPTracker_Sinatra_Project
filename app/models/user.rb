class User < ActiveRecord::Base
  belongs_to :person

  has_secure_password
  validates :username, presence: true, uniqueness: true
end
