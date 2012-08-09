
require 'nokogiri'
require 'uri'

`rm log/ken_cookie`
`curl --cookie log/ken_cookie --cookie-jar log/ken_cookie --location 'http://www.kenya-airways.com/default_en.aspx' > log/ken_call1`

def url_encode x
  return "" if x.nil?
  ret = URI.escape(x, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  ret = ret.gsub("%20", "+")
  ret
end

doc = Nokogiri::HTML(open("log/ken_call1"))
form = doc.css('form').first

hidden_inputs = form.css('input[@type = "hidden"]')

post_collection = hidden_inputs.map { |x| url_encode(x['name']) + '=' + url_encode(x['value']) }

post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$rblBooking=" + "R")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtDepartureDate=" + "08-08-2012")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtReturnDate=" + "18-08-2012")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$cmdGo=" + "Book now")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtDepartureDate_sch=" + "08-08-2012")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtReturnDate_sch=" + "18-08-2012")
#post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$cmdflightschedule=" + "18-08-2012")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtMDepartureDate1=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtMDepartureDate2=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtMDepartureDate3=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtMDepartureDate4=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtMDepartureDate5=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtMDepartureDate6=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtReference=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtFlightNo=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtLastName=")
post_collection << url_encode("ctl00$cph_flightsearch$pagekqbookingengine$txtPNR=")
post_collection << url_encode("ctl00$txtNewsLetter=")

post_string = post_collection.join "&"

puts "Post string is : " + post_string

`curl --cookie log/ken_cookie --cookie-jar log/ken_cookie --location 'http://www.kenya-airways.com/default_en.aspx' --data '#{post_string}' > log/ken_call2`
