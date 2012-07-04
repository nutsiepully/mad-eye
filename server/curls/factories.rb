#factories.rb
require 'nokogiri'

module AirlineRequestor
  def request(source,destination,start_date,return_date)
    raise NotImplementedError, "You should implement this method"
  end
end

class String
	def stripSpclChars
		self.gsub(/[^0-9A-Za-z,. ]/,'')
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

  $travel_class_map = {
    "economy" => "Economy",
    "business" => "Business"
  }

    $file_name="taag.req"
  #dateFormat 29/06/2012
  def request(source,destination,start_date,return_date,travel_class)
    @url="https://taag.sita.aero/itd/itd/DoAirSearch?_destinationSelected=Airport.#{destination}&_originSelected=Airport.#{source}&_adults=1&_children=0&_infants=0&_depdateeu=#{start_date}&_retdateeu=#{return_date}&_classType=#{travel_class}&requestor=AirSimpleReqs&_channelLocale=en"
	cli(@url,$file_name)
  end

  #might not need this as selected is the one which is cheap	
  def convertToNum(price)
  	return Float(price.gsub(/\s+/, "").gsub("USD ",""))
  end

  def compare(price1,price2)
  	return convertToNum(price1)>convertToNum(price2)? price2 : price1
  end

  def parse()
  	doc = Nokogiri::HTML(open($file_name))
	unless doc.css('span.error').nil? && doc.css('img.errorimage').nil?
		price1 = doc.css('td > div[@id = "jnytar1"]').first.css('td.headlineonewayprice > input[checked = "checked"].radio').first.parent.css('a').text.stripSpclChars
		price2 = doc.css('td > div[@id = "jnytar2"]').first.css('td.headlineonewayprice > input[checked = "checked"].radio').first.parent.css('a').text.stripSpclChars
		total = doc.css('td.totalled').css('div[style = "display:inline"].totalreturnprice').text.slice(/:.*/).strip.gsub(/:/,"").stripSpclChars
		puts price1+" "+price2+" "+total	
  	end
  end
 end

#TaagAirlineRequestor.new.request("LAD","LIS","02/07/2012","09/07/2012","Economy")
TaagAirlineRequestor.new.request("LAD","LIS","11/07/2012","29/07/2012","Economy")
TaagAirlineRequestor.new.request("GIG","LAD","17/07/2012","19/07/2012","Economy")
TaagAirlineRequestor.new.request("BRU","LAD","15/07/2012","22/07/2012","Economy")
#TaagAirlineRequestor.new.request("CDG","LAD","09/07/2012","17/07/2012","Economy")
#TaagAirlineRequestor.new.request("LIS","LAD","19/07/2012","29/07/2012","Economy")
TaagAirlineRequestor.new.parse
puts "Done!"

    
    
