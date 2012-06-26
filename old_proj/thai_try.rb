
require 'uri'
require 'nokogiri'

trip_type_string = "R" #O
origin = "sin"
destination = "kmg"
departure_date = Time.new(2012, 2, 1)
return_date = Time.new(2012, 2, 14)
travel_class = "PE" #FB

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

execute_str = "
	var val = CheckOK(\"#{trip_type_string}\", \"#{origin}\", \"#{destination}\", \"#{travel_class}\", \"#{get_date_month(departure_date)}\", \"#{get_date_day(departure_date)}\", \"#{get_date_month(return_date)}\", \"#{get_date_day(return_date)}\");
	print(val);
"
File.write("execute.js", execute_str)

`~/code/v8-read-only/d8 utility.js international.js execute.js > thai_url`

url = File.read('thai_url')
url = URI::encode(url)
so_gl = 'SO_GL=' + '%3C?xml%20version=%221.0%22%20encoding=%22iso-8859-1%22?%3E%3CSO_GL%3E%3CGLOBAL_LIST%20mode=%22complete%22%3E%3CNAME%3ESO_SINGLE_MULTIPLE_COMMAND_BUILDER%3C/NAME%3E%3CLIST_ELEMENT%3E%3CCODE%3E1%3C/CODE%3E%3CLIST_VALUE%3E%3C![CDATA[OS%20YY%20IP%20%3CCLIENT_IP_ADDRESS%3E]]%3E%3C/LIST_VALUE%3E%3CLIST_VALUE%3ES%3C/LIST_VALUE%3E%3C/LIST_ELEMENT%3E%3C/GLOBAL_LIST%3E%3C/SO_GL%3E'
url = url.gsub(/SO_GL=.*/, so_gl)

#url = url_encode url
puts url

`curl --dump-header thai_header_fcall_1 --cookie thai_cookie --cookie-jar thai_cookie --location 'http://www.thaiairways.com/' > thai_fcall_1`
`curl --dump-header thai_header_fcall_2 --cookie thai_cookie --cookie-jar thai_cookie --location 'http://www.thaiairways.com/booking-form/en/international.html' > thai_fcall_2`

`curl --globoff --dump-header thai_header_pcall --cookie thai_cookie --cookie-jar thai_cookie --location '#{url}' > thai_pcall.html`

doc = Nokogiri::HTML(open('thai_pcall.html'))
if doc.content.include? "We are unable to find recommendations for your search. Please change your search criteria and resubmit the search. (66002 [-1])"
	puts :route_not_supported
	exit
end

elem = doc.css('td#cell_3_3').first
if elem.nil?
	puts :error
	exit
end

price_str = elem.content.strip
if price_str == "Sold Out"
	puts :different_dates
	exit
end

puts price_str.split('$')[1].to_f

