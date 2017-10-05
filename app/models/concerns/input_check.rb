module InputCheck
  module InstanceMethods

    def emtpy_input?(hash)
      hash.values.any? {|v| v.empty? }
    end

  end
end
