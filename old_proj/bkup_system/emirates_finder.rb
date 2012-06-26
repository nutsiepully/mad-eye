
require 'uri'

class EmiratesFinder

	$travel_class_map = {
		"economy" => "0",
		"business" => "1"#,
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
		error_elem = doc.css("div#ctl00_c_pnlError").first
		if not error_elem.nil?
			err_msg = error_elem.css('li').first.content
			case err_msg
			when "Sorry, we were unable to price the requested flight. Please try again."
				return :different_dates
			when "Sorry, no flights or fares are available for your selected date combination. Please select a fare on a different date combination from the options provided below."
				return :different_dates
			when "Sorry, either flights are unavailable, or seats are not available on the flights for the routes / dates you have selected. Please try a new search, selecting Search by Schedule (at the end of the search options on this page) to search for alternate flights, routes or dates."
				return :different_dates
			when "Please provide all required information."
				return :route_not_supported
			when "Sorry, we were temporarily unable to process your request due to a technical problem."
				return :call_failed
			end
			return err_msg
		end

		return :route_not_supported if doc.css('div#ctl00_c_interlinePanelOpen').first['style'].include? "visible"

		price_elem = doc.css("div#ctl00_c_CtrlFltResult_ctl00_divOption")
		price_elem1 = price_elem.css('span.price').first
		return :route_not_supported if price_elem1.nil?
		price_str = price_elem.css('span.price').first.content.strip
		price = Price.new("Lowest available fare", price_str.split[0], price_str.split[1])

		dep_stop_count = 0
		dep_table = doc.css('div#ctl00_c_CtrlFltResult_ctl00_ctl00_pnltable')
		dep_table.css('td [headers=duration_stops10]').each do |stop|
			dep_stop_count += stop.text[-7].to_i + 1 - 48
		end

		ret_stop_count = 0
		ret_table = doc.css('div#ctl00_c_CtrlFltResult_ctl00_ctl01_pnltable')
		ret_table.css('td [headers=duration_stops11]').each do |stop|
			ret_stop_count += stop.text[-7].to_i + 1 - 48
		end

		[[price], dep_stop_count, ret_stop_count]
	end

	def get_result_file_name record, i
		"#{$airline}_calls/#{i}_#{record.origin}_#{record.destination}_#{record.travel_class}"
	end

	def get_call_directory
		"#{$airline}_calls/"
	end

	def get_date_string date_obj
		months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
		(date_obj.day > 9 ? "" : "0") + date_obj.day.to_s + "+" + months[date_obj.month - 1] + "+" + date_obj.year.to_s[-2..-1]
	end

	def get_result_for_record record, i
		puts; puts "Fetching records from server from  #{record.origin} to #{record.destination}. Counter at #{i}"

		trip_type_string = record.trip_type == :one_way ? "oneway" : "rbReturn"
		chk_return = record.trip_type == :one_way ? "" : "on"

		post_data_str = "__VIEWSTATE=&__VIEWSTATEENCRYPTED=&siteSelectorID=0&panelOpen=slideFlightSearch&LoginClick=&Itinerary=#{trip_type_string}&seldcity1=#{record.origin}&seldcity1-suggest=Hong+Kong+%28HKG%29&selddate1=#{get_date_string(record.departure_date)}&selcabinclass=#{record.travel_class}&selacity1=#{record.destination}&selacity1-suggest=New+York+%28JFK%29&seladate1=#{get_date_string(record.return_date)}&selcabinclass1=#{record.travel_class}&seladults=1&selchildren=0&selinfants=0&resultby=0&redeemforValue=&ctl00%24MainContent%24ctl20%24ctl07%24btnStartBooking=Find+Flights&txtPromoCode=&j=t&multiCity=&chkReturn=#{chk_return}&redeemChecked=&redeemfor=&flex=0&interline=0&LoginButtonEnabled=1&signon=&departDate=01022012&lpHotelCar=H&HotelCity=&HotelCity-suggest=&lphsdate=25+Jan+12&lphedate=&selrooms=1&seladults1=1&children1=0&ages1_1=2&ages1_2=2&ages1_3=2&seladults2=1&children2=0&ages2_1=2&ages2_2=2&ages2_3=2&lphopt1=0&lphopt2=0&CarCity=&CarCity-suggest=&calPickupDate=24+Jan+12&selPickupTime=12&selPickupMin=00&calDropOffDate=&selDropOffTime=12&selDropOffMin=00&lpcopt1=0&lpcopt2=0&rmdetails=1A&lphcityName=&lphcity=&lpccityName=&lpcsdate=&lpcedate=&lpccity=&lastname2=&bookref2=&lastname=&bookref=&seldcity2=&flightno=&FSSearchBy=FSFlightNumber&txtFSFlightNumber=&ddlFSDepartureAirport=&ddlFSDepartureAirport-suggest=Departure+Airport&ddlFSArrivalAirport=&ddlFSArrivalAirport-suggest=Arrival+Airport&ddlFSDepartureDate=24-Jan-2012&FSArrivalDeparture=FSDeparture&SFSearchBy=rbSFFlightNumber&txtSFFlightNumber=&ddlSFDepartureAirport=&ddlSFDepartureAirport-suggest=Departure+Airport&ddlSFArrivalAirport=&ddlSFArrivalAirport-suggest=Arrival+Airport&calSFDeparture=24+Jan+12&HttpsMode=true&NewHomePage=true&currentPanelOpen=slideFlightSearch&__SEOVIEWSTATE=2mYK2YsvNnPjV9%2BjnvKIWg6b15ZNiEJeF3gLXE3iSl7foZ1IHQrATuNgK8YcfT%2F56j8S8mcqRA%2FRnaBFS7s6ZxDjjaivilAK7J0HRzah9CxdbShoxTjeOF%2BaC4kbdH28JYgIXSlFxQtztOIE%2F8YblQv4WgtKDomAD7thYTV5jCX4hLEYMctqhZnRU7gecnl7pCWoIu67Vf%2BBvwkclIz4hIhCIRVuoetpx7XEuYZGWAo86b1uvVdrX%2BG1EXeDKwUUL1wjZQx9rKXcG6iKbZ1KFlLj%2B7Qf8eQee3cU0LrzuXWMS5EuwbpXYm%2FZ5l1NZJugaPgEj0lf7kAxwpF%2BPEjmH8NCf9omIHW1jPgUIWv4YTkxTF8ji9L%2BLRN4oIkn5ADvRUVxBrxdaR1%2FiviDhPiXiSG1BrfUWH9A9WrhcMXwAxiMaJK%2Bl1VF%2B2lFYHCXjowGbLb2yg1hWk4QvVOoww6pizaLhn8xkFtsJSeKrdKJKO8AR846sbc6c1%2BOw8pQ7X%2BWA%2Fpt1jKltqhmVx82E3NQ0%2BYoARfg9j55zq16IP2oFa4SYrSTqMHBs%2FosxFbSn1cM1qjJkz8hsEItBIwxKlANs5s2V8Synz6s3yhwWPEE9MjhsMus6i%2FC%2FkCggvBWi3Tkto9P8yOhYnqXMI5LnzSCQoM1EregsnCOEmAZGa0Bwy09dIAThpgI1TP1SIALwd5XClVt4dTIRyp6KapnerErmAlOaAsHppS6RDtgk1pRrTozWdVnkvfd6NWKVefAKQIh30s25S9gfNpIqfD0mauYTLuIyBnf7%2FuzcgL3D%2Fz9G8%2BGH2XRNyFeR09XgHHXiA5oDTcRsrm6R6FwM2ExyUw5JHR5BgqfXm734VcOgzAbcpN8Qi5oh9FUDm2ukH%2FS3nxJTpNpuTk5LG3whfwG9bCRs4sfYJZgBdWCxrTeKcNEYRjVQwAZjrJPAsufjXoWxeVhck7drPhzyBJVG%2B8Zo3Jg3lO1%2FsS%2B5aIvDjRgvzNOQTaMXGor98LAjJtLaIdsje6WWORKSfcRbUdUOfUiF9kyT1pSv2oD1xkHsdKaDJ0gzjx9wjdXMaWmeTuzlc41krYsWTld8Olp9e5RLSM%2FF4PA%2BoTAW5SVM%2F4JiQonOAIJAUP3ww4QpSqA75oYb5Fi%2FVbeFPBPnHG20D2cZnE%2BahjsNw%3D%3D"

		pcall_str = "curl --dump-header #{get_result_file_name(record, i)}_headers_1 --cookie #{get_call_directory}cookie --cookie-jar #{get_call_directory}cookie --location 'http://www.emirates.com/de/english/index.aspx' --data '#{post_data_str}' > #{get_result_file_name(record, i)}_1"
		`#{pcall_str}`

		doc = Nokogiri::HTML(open(get_result_file_name(record, i) + "_1"))
		form = doc.css('form').first
		action = form['action']
		inputs = form.css('input')

		input_strs = inputs.map { |x| url_encode(x['name']) + '=' + url_encode(x['value']) }
		input_string = input_strs.join "&"

		command = "curl --dump-header #{get_result_file_name(record, i)}_headers --cookie #{get_call_directory}cookie --cookie-jar #{get_call_directory}cookie --location '#{action}' --data '#{input_string}' > #{get_result_file_name(record, i)}"
		puts "Command is #{command}"
		`#{command}`

	end

	def refresh_session i
		puts; puts "Refreshing session with counter at #{i}"

		`rm #{$airline}_calls/cookie`
		`curl --dump-header #{$airline}_calls/#{i}_header_fcall --cookie #{$airline}_calls/cookie --cookie-jar #{$airline}_calls/cookie --location 'http://www.emirates.com/de/english/index.aspx' > #{$airline}_calls/#{i}_fcall`
	end
end
