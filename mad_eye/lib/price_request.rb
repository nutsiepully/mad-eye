
class PriceRequest

  @@airlines = ["TAAG", "TAP", "SAA", "ETH", "EMI", "KEN", "TEST"]

	attr_accessor :airline, :origin, :destination, :onward_date, :return_date, :travel_class

  def initialize airline_name, origin, destination, onward_date_str, return_date_str, travel_class
    raise ArgumentError.new "Airline Name is invalid" if not @@airlines.include? airline_name.upcase
    @airline = airline_name
    @onward_date = DateTime.parse onward_date_str
    @return_date = DateTime.parse return_date_str
    # TODO: could put origin and destination validation here
    @origin = origin
    @destination = destination
    @travel_class = travel_class
  end

  def request_hash
    "#{airline}|#{origin}|#{destination}|#{onward_date}|#{return_date}|#{travel_class}"
  end

end
