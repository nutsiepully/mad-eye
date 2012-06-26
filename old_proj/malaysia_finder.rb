
require 'uri'

class MalaysiaFinder

	@@travel_class_map = {
		"economy" => "Economy",
		"business" => "Business"#,
		#"first/suites" => "P"
	}

	# Mozilla/5.0 (Ubuntu; X11; Linux x86_64; rv:8.0) Gecko/20100101 Firefox/8.0

	def initialize
		@departure_date = nil
		@return_date = nil
		@trip_type_string = nil
	end

	def map_travel_class travel_class
		return nil if travel_class.nil? || travel_class.strip.empty?
		travel_class.strip!
		@@travel_class_map[travel_class.downcase]
	end

	def fetch_price_from_table table, date
		headers = table.css('div.header')
		cols = headers.first.css('h6.date')
		sel = -1 
		cols.each_with_index do |col, ind| 
			sel = ind if col.content == get_date_display_string(date)
		end
		cols = table.css('div.row>div.calcell')
		error_elem = cols[sel].css('div.calmsg').first
		if not error_elem.nil?
			if error_elem.content == "Not Available" or error_elem.content = "Phone our call centre"
				return :different_dates
			end
		end
		price_elem = cols[sel].css('p.price').first
		if price_elem.nil?
			return :error
		end
		price_digit_elem = price_elem.css('span.priceDigit').first
		if price_digit_elem.nil?
			if price_elem.content.start_with? "Available"
				return :extract_from_sidebar
			else
				puts price_elem.content
				return :error
			end
		end
		price = price_digit_elem.content.to_f
		price
	end

	# Returns the price value for the route
	def fetch_price_result file_name
		doc = Nokogiri::HTML(open(file_name))

		book_elems = doc.css('h6.bold')
		book_elems.each do |elem|
			if elem.content == "I'm Booking"
				return :route_not_supported
			end
		end

		tables = doc.css('div.ibe_content_select_table')

		#price_str = doc.css('label.medgrey').first.css('div#sidepaneltotalPrice').first.content
		#puts price_str

		dep_price = fetch_price_from_table tables.first, @departure_date
		puts "Dep price : " + dep_price.to_s

		ret_price = nil
		if "Return" == @trip_type_string
			ret_price = fetch_price_from_table tables[1], @return_date
			puts "Ret price : " + ret_price.to_s
		end

		if "OneWay" == @trip_type_string
			if not dep_price.is_a? Float
				return dep_price
			end
		elsif "Return" == @trip_type_string
			if dep_price.is_a? Float and ret_price.is_a? Float
				dep_price += ret_price
			else
				return dep_price if not dep_price.is_a? Float
				return ret_price if not dep_price.is_a? Float
			end
		end

		price = Price.new("Lowest available fare", "", dep_price)

		[[price], "", ""]
	end

	def get_result_file_name record, i
		"#{$airline}_calls/#{i}_#{record.origin}_#{record.destination}_#{record.travel_class}.html"
	end

	def get_call_directory
		"#{$airline}_calls/"
	end

	def get_month_year date
		date.year.to_s + "-" + (date.month > 9 ? "" : "0") + date.month.to_s
	end

	def sanitize_date_day day
		(day > 9 ? "" : "0") + day.to_s
	end

	def get_date_display_string date
		months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
		date.day.to_s + " " + months[date.month - 1]
	end

	def get_result_for_record record, i
		puts; puts "Fetching records from server from  #{record.origin} to #{record.destination}. Counter at #{i}"

		@departure_date = record.departure_date
		@return_date = record.return_date

		trip_type_string = record.trip_type == :one_way ? "OneWay" : "Return"
		@trip_type_string = trip_type_string

		`curl --dump-header #{get_result_file_name(record, i)}_headers --referer 'http://www.malaysiaairlines.com/my/en.html' --cookie #{get_call_directory}cookie --cookie-jar #{get_call_directory}cookie --user-agent 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.2 (KHTML, like Gecko) Ubuntu/11.10 Chromium/15.0.874.106 Chrome/15.0.874.106 Safari/535.2' --location 'https://book.malaysiaairlines.com/itd/itd/DoAirSearch?_tripType=#{trip_type_string}&_originSelected=Airport.#{record.origin}&_destinationSelected=Airport.#{record.destination}&daysofweekselect1=&_depdate.day=#{sanitize_date_day(record.departure_date.day)}&_depdate.monthyear=#{get_month_year(record.departure_date)}&daysofweekselect2=&_retdate.day=#{sanitize_date_day(record.return_date.day)}&_retdate.monthyear=#{get_month_year(record.return_date)}&_adults=1&_children=0&_infants=0&_classType=#{record.travel_class}&_channelLocale=en&_depdatewindow=P3D' > #{get_result_file_name(record, i)}`

	end

	def refresh_session i
		puts; puts "Refreshing session with counter at #{i}"

		`rm #{$airline}_calls/cookie`
		`curl --dump-header #{$airline}_calls/#{i}_header_fcall --referer 'http://www.malaysiaairlines.com/my/en.html' --cookie #{$airline}_calls/cookie --cookie-jar #{$airline}_calls/cookie --user-agent 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.2 (KHTML, like Gecko) Ubuntu/11.10 Chromium/15.0.874.106 Chrome/15.0.874.106 Safari/535.2' --location 'http://www.malaysiaairlines.com/my/en.html' > #{$airline}_calls/#{i}_fcall`
	end
end

