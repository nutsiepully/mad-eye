
require 'nokogiri'
require 'uri'

`rm cp_cookie`
`curl --dump-header qan_fcall_header --cookie qan_cookie --cookie-jar qan_cookie --location 'http://www.qantas.com.au/travel/airlines/home/au/en' > qan_fcall`

dep_city = "SIN"
ret_city = "ZRH"
dep_date = "20120129"
ret_date = "20120130"
trip_type = "R" # "O"
travel_class = "ECO" # "BUS"

`curl --dump-header qan_pcall_header --cookie qan_cookie --cookie-jar qan_cookie --location 'http://www.qantas.com.au/tripflowapp/flights.tripflow' --data 'depAirports=#{dep_city}%2C#{ret_city}&destAirports=#{ret_city}%2C#{dep_city}&travelDates=#{dep_date}0000%2C#{ret_date}0000&adults=1&children=0&infants=0&searchOption=M&tripType=#{trip_type}&travelClass=#{travel_class}&PAGE_FROM=%2Ftravel%2Fairlines%2Fflight-search%2Fglobal%2Fen&localeOverride=en_AU' > qan_pcall`

def url_encode x
	ret = URI.escape(x, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
	ret = ret.gsub("%20", "+")
end

doc = Nokogiri::HTML(open("qan_pcall"))

form = doc.css('form [name=SubmissionDetails]').first
action = form['action']
inputs = form.css('input')

input_strs = inputs.map { |x| url_encode(x['name']) + '=' + url_encode(x['value']) }
input_string = input_strs.join "&"

command = "curl --dump-header qan_pcall2_header --cookie qan_cookie --cookie-jar qan_cookie --location '#{action}' --data '#{input_string}' > qan_pcall2.html"
#puts "Command is #{command}"
`#{command}`

doc = Nokogiri::HTML(open("qan_pcall2.html"))


