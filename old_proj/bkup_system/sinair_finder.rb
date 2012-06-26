
class SinairFinder

	public

	$travel_class_map = {
		"economy" => "Y",
		"business" => "J"#,
		#"first/suites" => "P"
	}

	def map_travel_class travel_class
		return nil if travel_class.nil? || travel_class.strip.empty?
		travel_class.strip!
		$travel_class_map[travel_class.downcase]
	end

	# Returns the price value for the route
	def fetch_price_result file_name
		puts "Fetching price from file #{file_name}"
		doc = Nokogiri::HTML(open(file_name))

		alert = doc.css("div.alertMsg")
		if not alert.empty?
			alert_msg = alert.css("p").first.content.strip

			if /Please note that Singapore Airlines does not operate.*/.match(alert_msg)
				return :not_available
			end

			case alert_msg
			when "Please try again later. If the problem persists please contact your Travel Support Desk."
				return :call_failed
			when "We are unable to process your request at this moment due to a temporary technical issue in this page. Please try again."
				return :call_failed
			when "An application error occurred. Please contact your local Singapore Airlines office."
				return :call_failed
			when "There are no flights available on the dates you selected. Please use the calendar below to choose different dates."
				return :different_dates
			when "There are no seats or flights available for the dates you requested. Please change the dates and retry."
				return :different_dates
			when "Sorry. We do not have any online fares for the itinerary you have selected. Please contact your local Singapore Airlines reservations office to perform this booking."
				return :route_not_supported
			when "Please note that Singapore Airlines does not operate ECONOMY class in the selected dates between Singapore (SIN) and New York (EWR). The fares in the next best available cabin class are shown below:"
				return :not_available
			else
				puts "Unrecognized alert message : #{alert_msg}"
				# Returning call failed in case the error was due to a website issue
				return :call_failed
			end
		end

		price_table = doc.css("table.chooseFlightsData.jQchooseFlightHeader2")
		return :call_failed if price_table.empty?

		prices = []
		price_blocks = price_table.css("th>span.promotionOptions.disBlock")
		price_blocks.each do |price_block|
			price_category = price_block.css("a")[0].content.split(/[\n\t]+/).delete_if { |x| x.strip.empty? }.last
			price_category.strip!
			price_details = price_block.css("span.cfFareTotal")[0].content.split
			currency = price_details[0]
			price = price_details[1]

			prices << Price.new(price_category, currency, price)
		end

		# TODO: get values back
		sels = doc.css("tbody.jQdepartures>tr.jQflight").first
		dep_stop_count = sels.css("ul>li.divider").count

		ret_stop_count = "NA"
		sels = doc.css("tbody.jQreturns>tr.jQflight")
		unless sels.nil? or sels.empty?
			sels = sels.first
			ret_stop_count = sels.css("ul>li.divider").count
		end

		[ prices, dep_stop_count, ret_stop_count ]
	end

	def get_result_file_name record, i
		"#{$airline}_calls/#{i}_#{record.origin}_#{record.destination}_#{record.travel_class}"
	end

	def get_result_for_record record, i
		puts; puts "Fetching records from server from  #{record.origin} to #{record.destination}. Counter at #{i}"

		trip_type_string = record.trip_type == :one_way ? "&tripType=O" : ""

		post_data_string = "fromHomePage=true&recentSearches=&origin=#{record.origin}&destination=#{record.destination}&departureDay=#{record.departure_date.day}&departureMonth=#{record.departure_date.month_year_string}#{trip_type_string}&_tripType=on&returnDay=#{record.return_date.day}&returnMonth=#{record.return_date.month_year_string}&cabinClass=#{record.travel_class}&numOfAdults=#{record.num_adults}&numOfChildren=0&numOfInfants=0&_eventId_flightSearchEvent=&isLoggedInUser=false&numOfChildNominees=&numOfAdultNominees="

		result_file_name = get_result_file_name record, i

		str = "curl --dump-header #{result_file_name + "_headers"}  --cookie cookie.file --cookie-jar cookie.file --location http://www.singaporeair.com/booking-flow.form?execution=e2s1 --data '#{post_data_string}' > #{result_file_name}"

		`#{str}`
	end

	def refresh_session i
		puts; puts "Refreshing session with counter at #{i}"

		`rm cookie.file`
		`curl --dump-header #{$airline}_calls/#{i}_header_fcall --cookie cookie.file --cookie-jar cookie.file --location http://www.singaporeair.com/SAA-flow.form > #{$airline}_calls/#{i}_fcall`
	end

end
