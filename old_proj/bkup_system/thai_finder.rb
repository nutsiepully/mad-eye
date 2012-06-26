
require 'uri'

class ThaiFinder

	@@travel_class_map = {
		"economy" => "PE",
		"business" => "FB"#,
		#"first/suites" => "P"
	}

	def initialize
	end

	def map_travel_class travel_class
		return nil if travel_class.nil? || travel_class.strip.empty?
		travel_class.strip!
		@@travel_class_map[travel_class.downcase]
	end

	def get_date_month t
		t.year.to_s + (t.month > 9 ? "" : "0") + t.month.to_s
	end

	def get_date_day t
		(t.day > 9 ? "" : "0") + t.day.to_s
	end

	def url_encode x
		return "" if x.nil?
		ret = URI.escape(x, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
		ret = ret.gsub("%20", "+")
	end

	def get_price_from_string str
		str.gsub(/[^\d\.]/, "").to_f
	end

	def get_error_content doc
	end

	# Returns the price value for the route
	def fetch_price_result file_name
		doc = Nokogiri::HTML(open(file_name))

		if @second_call_made
			m = /WDSError\.add\(\"(.*)\"\)/.match(doc.content)
			if not m.nil?
			if m[1] == "We are unable to find recommendations for your search. Please change your search criteria and resubmit the search. (66002 [-1])"
				return :route_not_supported
			elsif m[1] == "We are unable to find departing flights matching the criteria you specified. Please modify your selection and try again. (9100)"
				return :different_dates
			elsif m[1].start_with?("No available flights were found from")
				return :different_dates
			elsif m[1].start_with?("The departure time of your selected flight is only")
				return :different_dates
			elsif m[1].start_with?("We are unable to find returning flights matching the criteria you specified")
				return :different_dates
			else
				return :error
			end
			end
			price = get_price_from_string(doc.css('tr.fared2').first.css('td')[2].content)
			price = Price.new("Lowest available fare", "", price)
			return [[price], "", ""]
			#return doc.css('span#taxes_ADT').first.content
		end
	
		m = /WDSError\.add\(\"(.*)\"\)/.match(doc.content)
		if not m.nil?
		if m[1] == "We are unable to find recommendations for your search. Please change your search criteria and resubmit the search. (66002 [-1])"
			return :route_not_supported
		elsif m[1] == "We are unable to find departing flights matching the criteria you specified. Please modify your selection and try again. (9100)"
			return :different_dates
		elsif m[1].start_with?("No available flights were found from")
			return :different_dates
		elsif m[1].start_with?("The departure time of your selected flight is only")
			return :different_dates
		elsif m[1].start_with?("We are unable to find returning flights matching the criteria you specified")
			return :different_dates
		else
			return :error
		end
		end

		elem = doc.css('td#cell_3_3').first
		if elem.nil?
			return  :error
		end

		price_str = elem.content.strip
		if price_str == "Sold Out"
			return :different_dates
		end

		price = get_price_from_string price_str
		price = Price.new("Lowest available fare", "", price)
		[[price], "", ""]
	end

	def get_result_file_name record, i
		"#{$airline}_calls/#{i}_#{record.origin}_#{record.destination}_#{record.travel_class}.html"
	end

	def get_call_directory
		"#{$airline}_calls/"
	end

	def get_result_for_record record, i
		puts; puts "Fetching records from server from  #{record.origin} to #{record.destination}. Counter at #{i}"

		@second_call_made = false
		trip_type_string = record.trip_type == :one_way ? "O" : "R"

		execute_str = "
			var val = CheckOK(\"#{trip_type_string}\", \"#{record.origin}\", \"#{record.destination}\", \"#{record.travel_class}\", \"#{get_date_month(record.departure_date)}\", \"#{get_date_day(record.departure_date)}\", \"#{get_date_month(record.return_date)}\", \"#{get_date_day(record.return_date)}\");
			print(val);
		"
		f = File.open("execute.js", "wb")
		f << execute_str
		f.close

		`~/v8-read-only/d8 utility.js international.js execute.js > thai_url`

		url = File.read('thai_url')
		url = URI::encode(url)
		so_gl = 'SO_GL=' + '%3C?xml%20version=%221.0%22%20encoding=%22iso-8859-1%22?%3E%3CSO_GL%3E%3CGLOBAL_LIST%20mode=%22complete%22%3E%3CNAME%3ESO_SINGLE_MULTIPLE_COMMAND_BUILDER%3C/NAME%3E%3CLIST_ELEMENT%3E%3CCODE%3E1%3C/CODE%3E%3CLIST_VALUE%3E%3C![CDATA[OS%20YY%20IP%20%3CCLIENT_IP_ADDRESS%3E]]%3E%3C/LIST_VALUE%3E%3CLIST_VALUE%3ES%3C/LIST_VALUE%3E%3C/LIST_ELEMENT%3E%3C/GLOBAL_LIST%3E%3C/SO_GL%3E'
		url = url.gsub(/SO_GL=.*/, so_gl)

		#url = url_encode url
		puts url

		`curl --globoff --dump-header #{get_result_file_name(record, i)}_headers --cookie #{get_call_directory}cookie --cookie-jar #{get_call_directory}cookie --location '#{url}' > #{get_result_file_name(record, i)}`

		doc = Nokogiri::HTML(open("#{get_result_file_name(record, i)}"))
		if doc.css('table.tableHeader').first.content.strip == "Select your flights"
			puts "Another call needs to be made to select flights"
			@second_call_made = true
			form = doc.css('form [name=SDAIForm]').first
			action = "https://wftc3.e-travel.com" + form['action']

			inputs = form.css('input [type=hidden]')
			input_strs = inputs.map { |x| url_encode(x['name']) + '=' + url_encode(x['value']) }
			input_strs << "ROW_1=0"
			input_strs << "ROW_2=0"
			input_strs << "CABIN=" + (record.travel_class == "PE" ? "E" : "B")
			input_strs << "RESTRICTION=true"
			input_string = input_strs.join "&"

			command = "curl --dump-header #{get_result_file_name(record, i)}_headers_2 --cookie #{get_call_directory}cookie --cookie-jar #{get_call_directory}cookie --location '#{action}' --data '#{input_string}' > #{get_result_file_name(record, i)}"
			puts "Command is #{command}"
			`#{command}`
		end

	end

	def refresh_session i
		puts; puts "Refreshing session with counter at #{i}"

		return
		`rm #{$airline}_calls/cookie`
		`curl --dump-header #{$airline}_calls/#{i}_header_fcall_1 --cookie #{$airline}_calls/cookie --cookie-jar #{$airline}_calls/cookie --location 'http://www.thaiairways.com/' > #{$airline}_calls/#{i}_fcall_1`
		`curl --dump-header #{$airline}_calls/#{i}_header_fcall_2 --cookie #{$airline}_calls/cookie --cookie-jar #{$airline}_calls/cookie --location 'http://www.thaiairways.com/booking-form/en/international.html' > #{$airline}_calls/#{i}_fcall_2`
	end
end

