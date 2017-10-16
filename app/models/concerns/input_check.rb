module InputCheck
  module InstanceMethods

    def emtpy_input?(hash)
      hash.values.any? {|v| v.empty? }
    end

    def user_friendly_date(attribute)
      attribute.to_date.strftime("%m/%d/%Y")
    end
  end
end
