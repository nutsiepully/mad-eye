#factories.rb
require 'nokogiri'

module AirlineRequestor
  def request(source,destination,start_date,return_date)
    raise NotImplementedError, "You should implement this method"
  end
end

def cli(url,file)
  puts "#{url}"
  user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.43 Safari/536.11"
  header_language="Accept-Language: en-US,en;q=0.8"
  header_charset="Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"

  `rm cookie.file`
  `curl --dump-header #{file}_header --cookie cookie.file --cookie-jar cookie.file --header '#{header_language}' --header '#{header_charset}' --user-agent '#{user_agent}' --location '#{url}' > #{file}`
end

class TaagAirlineRequestor
  include AirlineRequestor
  file_name = "taag.req"

  $travel_class_map = {
    "economy" => "Economy",
    "business" => "Business"
  }

  def request(source,destination,start_date,return_date,travel_class)
  #dateFormat 29/06/2012
    url="https://taag.sita.aero/itd/itd/DoAirSearch?_destinationSelected=Airport.#{destination}&_originSelected=Airport.#{source}&_adults=1&_children=0&_infants=0&_depdateeu=#{start_date}&_retdateeu=#{return_date}&_classType=#{travel_class}&requestor=AirSimpleReqs&_channelLocale=en"
    cli(url,file_name)
  end

  def parse
  	doc = Nokogiri::HTML(open(file_name))
	puts doc.css("td data block matrix headlineonewayprice fmt1")
		
  end 
end  

#TaagAirlineRequestor.new.request("LAD","LIS","02/07/2012","09/07/2012","Economy")
TaagAirlineRequestor.new.parse
puts "Done!"

    
    
