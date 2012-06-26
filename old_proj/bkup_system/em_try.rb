
require 'nokogiri'
require 'uri'

`rm em_cookie`
`curl --dump-header em_fcall_headers --cookie em_cookie --cookie-jar em_cookie --location 'http://www.emirates.com/de/english/index.aspx' > em_fcall`

dep_city = "SIN"
arr_city = "JNB"
dep_date = "28+Jan+12"
arr_date = "29+Jan+12"
travel_class = "1"
trip_type = "rbReturn" #"oneway"# : "rbReturn"

post_data_str = "__VIEWSTATE=&__VIEWSTATEENCRYPTED=&siteSelectorID=0&panelOpen=slideFlightSearch&LoginClick=&Itinerary=#{trip_type}&seldcity1=#{dep_city}&seldcity1-suggest=Hong+Kong+%28HKG%29&selddate1=#{dep_date}&selcabinclass=#{travel_class}&selacity1=#{arr_city}&selacity1-suggest=New+York+%28JFK%29&seladate1=#{arr_date}&selcabinclass1=#{travel_class}&seladults=1&selchildren=0&selinfants=0&resultby=0&redeemforValue=&ctl00%24MainContent%24ctl20%24ctl07%24btnStartBooking=Find+Flights&txtPromoCode=&j=t&multiCity=&chkReturn=on&redeemChecked=&redeemfor=&flex=0&interline=0&LoginButtonEnabled=1&signon=&departDate=01022012&lpHotelCar=H&HotelCity=&HotelCity-suggest=&lphsdate=25+Jan+12&lphedate=&selrooms=1&seladults1=1&children1=0&ages1_1=2&ages1_2=2&ages1_3=2&seladults2=1&children2=0&ages2_1=2&ages2_2=2&ages2_3=2&lphopt1=0&lphopt2=0&CarCity=&CarCity-suggest=&calPickupDate=24+Jan+12&selPickupTime=12&selPickupMin=00&calDropOffDate=&selDropOffTime=12&selDropOffMin=00&lpcopt1=0&lpcopt2=0&rmdetails=1A&lphcityName=&lphcity=&lpccityName=&lpcsdate=&lpcedate=&lpccity=&lastname2=&bookref2=&lastname=&bookref=&seldcity2=&flightno=&FSSearchBy=FSFlightNumber&txtFSFlightNumber=&ddlFSDepartureAirport=&ddlFSDepartureAirport-suggest=Departure+Airport&ddlFSArrivalAirport=&ddlFSArrivalAirport-suggest=Arrival+Airport&ddlFSDepartureDate=24-Jan-2012&FSArrivalDeparture=FSDeparture&SFSearchBy=rbSFFlightNumber&txtSFFlightNumber=&ddlSFDepartureAirport=&ddlSFDepartureAirport-suggest=Departure+Airport&ddlSFArrivalAirport=&ddlSFArrivalAirport-suggest=Arrival+Airport&calSFDeparture=24+Jan+12&HttpsMode=true&NewHomePage=true&currentPanelOpen=slideFlightSearch&__SEOVIEWSTATE=2mYK2YsvNnPjV9%2BjnvKIWg6b15ZNiEJeF3gLXE3iSl7foZ1IHQrATuNgK8YcfT%2F56j8S8mcqRA%2FRnaBFS7s6ZxDjjaivilAK7J0HRzah9CxdbShoxTjeOF%2BaC4kbdH28JYgIXSlFxQtztOIE%2F8YblQv4WgtKDomAD7thYTV5jCX4hLEYMctqhZnRU7gecnl7pCWoIu67Vf%2BBvwkclIz4hIhCIRVuoetpx7XEuYZGWAo86b1uvVdrX%2BG1EXeDKwUUL1wjZQx9rKXcG6iKbZ1KFlLj%2B7Qf8eQee3cU0LrzuXWMS5EuwbpXYm%2FZ5l1NZJugaPgEj0lf7kAxwpF%2BPEjmH8NCf9omIHW1jPgUIWv4YTkxTF8ji9L%2BLRN4oIkn5ADvRUVxBrxdaR1%2FiviDhPiXiSG1BrfUWH9A9WrhcMXwAxiMaJK%2Bl1VF%2B2lFYHCXjowGbLb2yg1hWk4QvVOoww6pizaLhn8xkFtsJSeKrdKJKO8AR846sbc6c1%2BOw8pQ7X%2BWA%2Fpt1jKltqhmVx82E3NQ0%2BYoARfg9j55zq16IP2oFa4SYrSTqMHBs%2FosxFbSn1cM1qjJkz8hsEItBIwxKlANs5s2V8Synz6s3yhwWPEE9MjhsMus6i%2FC%2FkCggvBWi3Tkto9P8yOhYnqXMI5LnzSCQoM1EregsnCOEmAZGa0Bwy09dIAThpgI1TP1SIALwd5XClVt4dTIRyp6KapnerErmAlOaAsHppS6RDtgk1pRrTozWdVnkvfd6NWKVefAKQIh30s25S9gfNpIqfD0mauYTLuIyBnf7%2FuzcgL3D%2Fz9G8%2BGH2XRNyFeR09XgHHXiA5oDTcRsrm6R6FwM2ExyUw5JHR5BgqfXm734VcOgzAbcpN8Qi5oh9FUDm2ukH%2FS3nxJTpNpuTk5LG3whfwG9bCRs4sfYJZgBdWCxrTeKcNEYRjVQwAZjrJPAsufjXoWxeVhck7drPhzyBJVG%2B8Zo3Jg3lO1%2FsS%2B5aIvDjRgvzNOQTaMXGor98LAjJtLaIdsje6WWORKSfcRbUdUOfUiF9kyT1pSv2oD1xkHsdKaDJ0gzjx9wjdXMaWmeTuzlc41krYsWTld8Olp9e5RLSM%2FF4PA%2BoTAW5SVM%2F4JiQonOAIJAUP3ww4QpSqA75oYb5Fi%2FVbeFPBPnHG20D2cZnE%2BahjsNw%3D%3D"

pcall_str = "curl --dump-header em_pcall_headers --cookie em_cookie --cookie-jar em_cookie --location 'http://www.emirates.com/de/english/index.aspx' --data '#{post_data_str}' > em_pcall.html"
`#{pcall_str}`

def url_encode x
	return "" if x.nil?
	ret = URI.escape(x, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
	ret = ret.gsub("%20", "+")
end

doc = Nokogiri::HTML(open('em_pcall.html'))
form = doc.css('form').first
action = form['action']
inputs = form.css('input')

input_strs = inputs.map { |x| url_encode(x['name']) + '=' + url_encode(x['value']) }
input_string = input_strs.join "&"

command = "curl --dump-header em_pcall2_header --cookie em_cookie --cookie-jar em_cookie --location '#{action}' --data '#{input_string}' > em_pcall2.html"
puts "Command is #{command}"
`#{command}`

doc = Nokogiri::HTML(open('em_pcall2.html'))
error_elem = doc.css("div#ctl00_c_pnlError").first
puts error_elem
if not error_elem.nil?
	puts error_elem.css('li').first.content
	exit
end

price_elem = doc.css("div#ctl00_c_CtrlFltResult_ctl00_divOption")
price_str = price_elem.css('span.price').first.content.strip

puts price_str

