module DateExtensions
  class DateTime
    def date_string
      self.strftime "%Y-%m-%d"
    end
  end
end
