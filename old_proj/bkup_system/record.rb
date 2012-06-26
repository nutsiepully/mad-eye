
require 'date'

# Class that encapsulates
class Record
	attr_accessor :origin, :destination, :departure_date, \
		:return_date, :trip_type, :travel_class, :num_adults, :prices, :stop_count

	attr_accessor :error_message

	def valid?
		@valid
	end

	def already_has_schedule?
		@prices.values.any? { |val| val.is_a? Price }
	end

	def stop_count_string
		str = ""
		["economy", "business"].each do |travel_class|
			if not @stop_count[travel_class].nil?
				str = [str, @stop_count[travel_class].join(",")].join ","
			end
		end
		str
	end

	def to_s
		"{Valid = #{@valid}, Origin = #{@origin}, Destination = #{@destination}, Departure Date = #{@departure_date}, Return Date = #{@return_date}, Trip Type = #{@trip_type}, Num Adults = #{@num_adults}, Prices = #{@prices}, Stop Count = #{@stop_count}"
	end

	def initialize row
		@valid = true
		@prices = {}
		@stop_count = {}

		@origin = row[1]
		if @origin.nil?
			@valid = false
			@error_message = "Bad Origin Value"
			return
		end
		@origin.upcase!

		@destination = row[2]
		if @destination.nil?
			@valid = false
			@error_message = "Bad Destination Value"
			return
		end
		@destination.upcase!

		@trip_type = row[3].downcase == "return" ? :return : :one_way

		begin
			@departure_date = DateTime.parse(row[4].strip).to_time
		rescue
			@valid = false
			@error_message = "Bad Departure Date"
			return
		end

		if @trip_type == :return
			begin
				@return_date = DateTime.parse(row[5].strip).to_time
			rescue
				@valid = false
				@error_message = "Bad Return Date"
				return
			end
		else
			@return_date = @departure_date + 1
		end

		if @trip_type == :return and @departure_date > @return_date
			@valid = false
			@error_message = "Departure date further than Return Date"
			return
		end

		@num_adults = 1
	end
end

