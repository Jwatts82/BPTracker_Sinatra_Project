class Reading < ActiveRecord::Base
  include Input::InstanceMethods

  belongs_to :user
  has_many :comment_readings, dependent: :destroy
  has_many :comments, through: :comment_readings

  def category_selector(sbp, dbp)
    systolic = sbp.to_i
    diastolic = dbp.to_i

    case
    when systolic.between?(70, 89) && diastolic.between?(40, 59)
      return 'L'
    when systolic.between?(90, 119) && diastolic.between?(60, 79)
      return 'N'
    when systolic.between?(120, 139) && diastolic.between?(80, 89)
      return 'P-HBP'
    when systolic.between?(140, 159) && diastolic.between?(90, 99)
      return 'HBP-1'
    when systolic.between?(160, 190) && diastolic.between?(100, 110)
      return 'HBP-2'
    end
  end

  def datetime_sql_insert(date, time)
    date + ' ' + time
  end

  def cpu_date
    reading_date_time.strftime("%Y-%m-%d")
  end

  def cpu_time
    reading_date_time.strftime("%I:%M")
  end

  def user_friendly_time
    reading_date_time.strftime("%I:%M%p")
  end
end
