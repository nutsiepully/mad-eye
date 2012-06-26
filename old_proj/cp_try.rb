
require 'nokogiri'
require 'uri'

`rm cp_cookie`
`curl --dump-header cp_fcall_header --cookie cp_cookie --cookie-jar cp_cookie --location 'http://www.cathaypacific.com/cpa/en_SG/homepage?CX_FCN=CXHOME0_CountryChange' > cp_fcall`

#`curl --dump-header cp_pcall_header --cookie cp_cookie --cookie-jar cp_cookie --location 'http://www.cathaypacific.com/wdsibe/jsp/singlecity/search.jsf?ACTION=SINGLE_CITY_SEARCH&ENTRYLANGUAGE=en&ENTRYCOUNTRY=SG&ENTRYPOINT=http://www.cathaypacific.com/cpa/en_SG/homepage&tripType=R&cabinClass=E&adult=1&child=0&infant=0&flexibleDate=true&departureDate=20120125&arrivalDate=20120130&origin=SIN&destination=HKG' > cp_pcall`

trip_type_string = "R" # "O"
origin = "HKG"
destination = "SIN"
cabin_class = "E" #"B"
departure_date = "20120201"
arrival_date = "20120214"

`curl --dump-header cp_pcall_header --cookie cp_cookie --cookie-jar cp_cookie --location 'http://www.cathaypacific.com/wdsibe/jsp/singlecity/search.jsf?ACTION=SINGLE_CITY_SEARCH&child=0&adult=1&ENTRYPOINT=http%3A%2F%2Fwww.cathaypacific.com%2Fcpa%2Fen_SG%2Fhomepage&ENTRYCOUNTRY=SG&tripType=#{trip_type_string}&ENTRYLANGUAGE=en&flexibleDate=true&destination=#{destination}&cabinClass=#{cabin_class}&origin=#{origin}&arrivalDate=#{arrival_date}&infant=0&departureDate=#{departure_date}&isChecked=true' > cp_pcall`

def url_encode x
	ret = URI.escape(x, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
	ret = ret.gsub("%20", "+")
end

doc = Nokogiri::HTML(open("cp_pcall"))

form = doc.css('form [name=SubmissionDetails]').first
action = form['action']
inputs = form.css('input')

input_strs = inputs.map { |x| url_encode(x['name']) + '=' + url_encode(x['value']) }
input_string = input_strs.join "&"

command = "curl --dump-header cp_pcall2_header --cookie cp_cookie --cookie-jar cp_cookie --location '#{action}' --data '#{input_string}' > cp_pcall2.html"
#puts "Command is #{command}"
`#{command}`

doc = Nokogiri::HTML(open("cp_pcall2.html"))

input_elem = doc.css("input [value=\"#{departure_date}0000|#{arrival_date}0000\"]").first
price_element = input_elem.next_element
puts price_element.content


