#factories.rb

module AirlineRequestor
  def request(source,destination,start_date,return_date)
    raise NotImplementedError, "You should implement this method"
  end
end

def cli(url,file)
  puts "#{url}"
  `rm cookie.file`
  `curl --dump-header #{file}_header --cookie cookie.file --cookie-jar cookie.file --location #{url} > #{file}`
end

class TaagAirlineRequestor
  include AirlineRequestor
  $travel_class_map = {
    "economy" => "Economy",
    "business" => "Business"
  }
  def request(source,destination,start_date,return_date,travel_class)
  #dateFormat 29/06/2012
    url="https://taag.sita.aero/itd/itd/DoAirSearch?_destinationSelected=Airport.#{destination}&_originSelected=Airport.#{source}&_adults=1&_children=0&_infants=0&_depdateeu=#{start_date}&_retdateeu=#{return_date}&_classType=#{travel_class}&requestor=AirSimpleReqs&_channelLocale=en"
    taag="taag.req"
    cli(url,taag)
  end
end  

TaagAirlineRequestor.new.request("LIS","LAD","29/06/2012","01/07/2012","Economy")
puts "Done!"

    
    
