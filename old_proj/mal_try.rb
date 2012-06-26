
require 'nokogiri'
require 'uri'

`rm mal_cookie`
`curl --dump-header mal_fcall_header --cookie mal_cookie --cookie-jar mal_cookie --trace-ascii mal_trace1 --referer 'Mozilla/5.0 (Ubuntu; X11; Linux x86_64; rv:8.0) Gecko/20100101 Firefox/8.0' --location 'http://www.malaysiaairlines.com/my/en.html' > mal_fcall`

#trip_type_string = "Return"
trip_type_string = "OneWay"
origin = "SIN"
destination = "KUL"
#cabin_class = "Economy" 
cabin_class = "Business" 
departure_date = Time.new(2012, 2, 1)
return_date = Time.new(2012, 2, 14)

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

`curl --dump-header mal_pcall_header --cookie mal_cookie --cookie-jar mal_cookie --trace-ascii mal_trace2 --referer 'Mozilla/5.0 (Ubuntu; X11; Linux x86_64; rv:8.0) Gecko/20100101 Firefox/8.0' --location 'https://book.malaysiaairlines.com/itd/itd/DoAirSearch?_tripType=#{trip_type_string}&_originSelected=Airport.#{origin}&_destinationSelected=Airport.#{destination}&daysofweekselect1=&_depdate.day=#{sanitize_date_day(departure_date.day)}&_depdate.monthyear=#{get_month_year(departure_date)}&daysofweekselect2=&_retdate.day=#{sanitize_date_day(return_date.day)}&_retdate.monthyear=#{get_month_year(return_date)}&_adults=1&_children=0&_infants=0&_classType=#{cabin_class}&_channelLocale=en&_depdatewindow=P3D' > mal_pcall.html`

doc = Nokogiri::HTML(open('mal_pcall.html'))

book_elems = doc.css('h6.bold')
book_elems.each do |elem|
	if elem.content == "I'm Booking"
		puts :route_not_supported
		exit
	end
end

tables = doc.css('div.ibe_content_select_table')

#price_str = doc.css('label.medgrey').first.css('div#sidepaneltotalPrice').first.content
#puts price_str

dep_price = fetch_price_from_table tables.first, departure_date
puts "Dep price : " + dep_price.to_s
if "Return" == trip_type_string
	ret_price = fetch_price_from_table tables[1], return_date
	puts "Ret price : " + ret_price.to_s
	#dep_price += ret_price
end

#puts dep_price

