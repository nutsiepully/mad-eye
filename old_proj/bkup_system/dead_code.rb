
=begin
class Location
	attr_accessor :code, :city, :country, :airport

	def initialize elem
		@code = elem.attributes['value']
		strs = elem.text.split ","
		@city = strs[0].downcase
		strs = strs[1].strip.split "("
		@country = strs[0].strip.downcase
		@airport = strs[1].strip.split("-")[0].strip.downcase
	end

	def to_s
		"{Code = #{@code}, City = #{@city}, Country = #{@country}, Airport = #{@airport}}"
	end
end

$locations_hash = {}

puts "Reading locations file"
file = File.new('locations.xml');
xml = Document.new(file);

puts "Generating locations hash"
xml.elements.each('/root/option') do |elem|
	loc = Location.new elem
	$locations_hash[loc.city] = loc
end
=end

=begin
def map_location loc
	return nil if loc.nil? || loc.strip.empty?
	loc.strip!
	loc_record = $locations_hash[loc.downcase]
	return loc_record.code if not loc_record.nil?
	nil
end
=end


# Old constructor for self sample file
=begin
	def initialize row
		@valid = true

		@origin = map_location row[0]
		if @origin.nil?
			@valid = false
			@error_message = "Bad Origin Value"
			return
		end

		@destination = map_location row[1]
		if @destination.nil?
			@valid = false
			@error_message = "Bad Destination Value"
			return
		end

		begin
			@departure_date = DateTime.parse(row[2].strip).to_time
		rescue
			@valid = false
			@error_message = "Bad Departure Date"
			return
		end

		begin
			if row[3].nil? or row[3].strip.empty?
				@return_date = nil
				@trip_type = :one_way
			else
				@return_date = DateTime.parse(row[3].strip).to_time
				@trip_type = :return
			end
		rescue
			@valid = false
			@error_message = "Bad Return Date"
			return
		end

		if @departure_date > @return_date
			@valid = false
			@error_message = "Departure date further than Return Date"
			return
		end

		@travel_class = map_travel_class row[4]
		if @travel_class.nil?
			@valid = false
			@error_message = "Bad Travel Class Value"
			return
		end

		if row[5].nil? || row[5].to_i <= 0
			@num_adults = 1
			return
		end
		@num_adults = row[5].to_i || 1
	end
=end

=begin
def is_header_row? row
	# TODO: Implement
end

def is_blank? row
	row.nil? || row.all? { |x| x.nil? }
end
=end

