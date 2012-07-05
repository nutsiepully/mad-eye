
class PriceRequest

  @@airlines = ["TAAG", "TAP", "SAA", "ETH", "EMI", "KEN"]

	attr_accessor :airline, :origin, :destination, :onward_date, :return_date, :travel_class

  def initialize airline_name, origin, destination, onward_date_str, return_date_str, travel_class
    raise ValidationError.new "Airline Name is invalid" if @@airlines.include? airline_name.upcase
    onward_date = DateTime.parse onward_date_str
    return_date = DateTime.parse return_date_str
  end

end
