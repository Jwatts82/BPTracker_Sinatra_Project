class User < ActiveRecord::Base
  include Input::InstanceMethods

  has_many :readings, dependent: :destroy
  has_many :comments, through: :readings

  has_secure_password
  validates :username, presence: true, uniqueness: true

  def age_calculator(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month ||
      (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
end
