class Person < ActiveRecord::Base
  include InputCheck::InstanceMethods

  has_many :users, dependent: :destroy
  has_many :readings, dependent: :destroy
  has_many :comments, through: :readings

  def age_calculator(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month &&
                                                  now.day >= dob.day)) ? 0 : 1)
  end

  def date
    dob.to_date.strftime("%m/%d/%Y")
  end
end
