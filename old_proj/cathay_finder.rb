
require 'uri'

class CathayFinder

	@@travel_class_map = {
		"economy" => "E",
		"business" => "B"#,
		#"first/suites" => "P"
	}

	def initialize
		@departure_date = nil
		@return_date = nil
		@result = nil
	end

	def map_travel_class travel_class
		return nil if travel_class.nil? || travel_class.strip.empty?
		travel_class.strip!
		@@travel_class_map[travel_class.downcase]
	end

	# Returns the price value for the route
	def fetch_price_result file_name
		puts "Fetching price from file #{file_name}"

		if not @result.nil?
			return @result
		end

		doc = Nokogiri::HTML(open(file_name))
		puts "!" * 50
		puts @departure_date
		puts @return_date
		search_str = ""
		if not @return_date.nil?
			search_str = "input [value=\"#{get_date_string(@departure_date)}0000|#{get_date_string(@return_date)}0000\"]"
		else
			search_str = "input [value=\"#{get_date_string(@departure_date)}0000\"]"
		end
		puts search_str
		input_elem = doc.css(search_str).first
		return :different_dates if input_elem.nil?
		price_element = input_elem.next_element
		price_str = price_element.content
		price = Price.new("Lowest available fare", price_str[0], price_str.gsub(/[^\d\.]/, "").to_f)

		[[price], "", ""]
	end

	def get_result_file_name record, i
		"#{$airline}_calls/#{i}_#{record.origin}_#{record.destination}_#{record.travel_class}.html"
	end

	def get_temp_result_file_name record, i
		"#{$airline}_calls/#{i}_#{record.origin}_#{record.destination}_#{record.travel_class}_1.html"
	end

	def get_call_directory
		"#{$airline}_calls/"
	end

	def get_date_string date_obj
		date_obj.year.to_s + (date_obj.month > 9 ? "" : "0") + date_obj.month.to_s + (date_obj.day > 9 ? "" : "0") + date_obj.day.to_s
	end

	def get_result_for_record record, i
		puts; puts "Fetching records from server from  #{record.origin} to #{record.destination}. Counter at #{i}"

		@departure_date = record.departure_date
		@return_date = record.trip_type == :one_way ? nil : record.return_date
		@result = nil

		trip_type_string = record.trip_type == :one_way ? "O" : "R"

		`curl --dump-header #{get_result_file_name(record, i)}_headers_1 --cookie #{get_call_directory}cookie --cookie-jar #{get_call_directory}cookie --location 'http://www.cathaypacific.com/wdsibe/jsp/singlecity/search.jsf?ACTION=SINGLE_CITY_SEARCH&child=0&adult=1&ENTRYPOINT=http%3A%2F%2Fwww.cathaypacific.com%2Fcpa%2Fen_SG%2Fhomepage&ENTRYCOUNTRY=SG&tripType=#{trip_type_string}&ENTRYLANGUAGE=en&flexibleDate=true&destination=#{record.destination}&cabinClass=#{record.travel_class}&origin=#{record.origin}&arrivalDate=#{get_date_string(record.return_date)}&infant=0&departureDate=#{get_date_string(record.departure_date)}&isChecked=true' > #{get_temp_result_file_name(record, i)}`

		doc = Nokogiri::HTML(open("#{get_temp_result_file_name(record, i)}"))

		error_element = doc.css('div.error')
		if not error_element.empty?
			error_msg = error_element.css('span').first.content
			if error_msg == "The route is not valid. Please select again."
				@result = :route_not_supported
				return
			elsif (/Please note that the flight between.*operates on.*/ =~ (error_msg)) != nil
				@result = :different_dates
				return
			end
		end

		form = doc.css('form [name=SubmissionDetails]').first
		action = form['action']
		inputs = form.css('input')

		input_strs = inputs.map { |x| url_encode(x['name']) + '=' + url_encode(x['value']) }
		input_string = input_strs.join "&"

		command = "curl --dump-header #{get_result_file_name(record, i)}_headers --cookie #{get_call_directory}cookie --cookie-jar #{get_call_directory}cookie --location '#{action}' --data '#{input_string}' > #{get_result_file_name(record, i)}"
		#puts "Command is #{command}"
		`#{command}`

	end

	def refresh_session i
		puts; puts "Refreshing session with counter at #{i}"

		`rm #{$airline}_calls/cookie`
		`curl --dump-header #{$airline}_calls/#{i}_header_fcall --cookie #{$airline}_calls/cookie --cookie-jar #{$airline}_calls/cookie --location 'http://www.cathaypacific.com/cpa/en_SG/homepage?CX_FCN=CXHOME0_CountryChange' > #{$airline}_calls/#{i}_fcall`
	end
end
