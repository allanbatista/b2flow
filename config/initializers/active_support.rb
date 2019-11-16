##
# set default datetime format for all application
module ActiveSupport
  class TimeWithZone
    def as_json(options = nil)
      strftime("%FT%T.%L%z")
    end
  end
end