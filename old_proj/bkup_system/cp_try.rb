
require 'nokogiri'
require 'uri'

`rm cp_cookie`
`curl --dump-header cp_fcall_header --cookie cp_cookie --cookie-jar cp_cookie --location 'http://www.cathaypacific.com/cpa/en_SG/homepage?CX_FCN=CXHOME0_CountryChange' > cp_fcall`

#`curl --dump-header cp_pcall_header --cookie cp_cookie --cookie-jar cp_cookie --location 'http://www.cathaypacific.com/wdsibe/jsp/singlecity/search.jsf?ACTION=SINGLE_CITY_SEARCH&ENTRYLANGUAGE=en&ENTRYCOUNTRY=SG&ENTRYPOINT=http://www.cathaypacific.com/cpa/en_SG/homepage&tripType=R&cabinClass=E&adult=1&child=0&infant=0&flexibleDate=true&departureDate=20120125&arrivalDate=20120130&origin=SIN&destination=HKG' > cp_pcall`

`curl --dump-header cp_pcall_header --cookie cp_cookie --cookie-jar cp_cookie --location 'http://www.cathaypacific.com/wdsibe/jsp/singlecity/search.jsf?ACTION=SINGLE_CITY_SEARCH&child=0&adult=1&ENTRYPOINT=http%3A%2F%2Fwww.cathaypacific.com%2Fcpa%2Fen_SG%2Fhomepage&ENTRYCOUNTRY=SG&tripType=R&ENTRYLANGUAGE=en&flexibleDate=true&destination=HKG&cabinClass=E&origin=SIN&arrivalDate=20120131&infant=0&departureDate=20120125&isChecked=true' > cp_call`

def url_encode x
	ret = URI.escape(x, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
	ret = ret.gsub("%20", "+")
end

doc = Nokogiri::HTML(open("cp_pcall"))

form = doc.css('form [name=SubmissionDetails]').first
action = form['action']
inputs = form.css('input')

input_strs = inputs.map { |x| x['id'] + '=' + url_encode(x['value']) }
input_string = input_strs.join "&"

command = "curl --dump-header cp_pcall2_header --cookie cp_cookie --cookie-jar cp_cookie --location '#{action}' --data '#{input_string}' > cp_pcall2.html"
puts "Command is #{command}"
`#{command}`

input_elem = doc.css('input [value="201201250000|201201310000"]').first
price_element = input_elem.next_element



