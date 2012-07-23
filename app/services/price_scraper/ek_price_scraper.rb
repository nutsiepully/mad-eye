
module PriceScraper
  class EkPriceScraper

    def scrape price_request
      curl_url price_request
      prices = parse price_request
      [ Price.get_price_object(price_request.request_hash, prices[0], prices[1], prices[2]) ]
    end

    def curl_url price_request
      curl_to_file price_request, "onward"
      curl_to_file price_request, "return"
      curl_to_file price_request, "total"
    end

    def curl_to_file price_request, price_type
      # First call to home page to gather cookies
      `rm log/em_cookie`
      `curl --cookie log/em_cookie --cookie-jar log/em_cookie --location 'http://www.emirates.com/us/english/index.aspx' > log/em_pcall`

      onward_date_string = (price_type == "return") \
          ? date_string_3(price_request.return_date) \
          : (price_type == "onward") \
              ? date_string_3(price_request.onward_date) \
              : date_string(price_request.onward_date)
      depart_date_string = (price_type != "return") ? date_string_2(price_request.onward_date) : date_string_2(price_request.return_date)

      return_date_string = price_type == "total" ? date_string(price_request.return_date) : ""
      #return_travel_class_string = price_type == "total" ? travel_class_string(price_request.travel_class) : ""
      return_travel_class_string = travel_class_string(price_request.travel_class)
      origin_string = price_type != "return" ? price_request.origin : price_request.destination
      destination_string = price_type != "return" ? price_request.destination : price_request.origin
      flight_type = price_type == "total" ? "rbReturn" : "oneway"
      tid_string = price_type == "total" ? "SB" : "OW"
      chk_return_str = price_type == "total" ? "on" : ""

      post_data = "pageurl=%2FIBE.aspx&section=IBE&bsp=Home&showpage=true&TID=#{tid_string}&siteSelectorID=0&Itinerary=#{flight_type}&seldcity1=#{origin_string}&seldcity1-suggest=Luanda+%28LAD%29&selddate1=#{onward_date_string}&selcabinclass=#{travel_class_string(price_request.travel_class)}&selacity1=#{destination_string}&selacity1-suggest=Lisbon+%28LIS%29&seladate1=#{return_date_string}&selcabinclass1=#{return_travel_class_string}&seladults=1&selchildren=0&selinfants=0&resultby=0&redeemforValue=&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl07%24btnStartBooking=Find+Flights&txtPromoCode=&j=t&multiCity=&chkReturn=#{chk_return_str}&redeemChecked=&redeemfor=&flex=0&interline=0&LoginButtonEnabled=1&signon=&departDate=#{depart_date_string}&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl07%24hdnSlideOmnitureEnabledFSearch=True&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl07%24hdnSlideOmnitureTimeSpendFSearch=1000&EnableInterlinePriceOptions=0&DefaultInterlineResultsBy=0&DefaultResultsBy=2&lpHotelCar=H&HotelCity=&HotelCity-suggest=&lphsdate=24+Jul+12&lphedate=&selrooms=1&seladults1=1&children1=0&ages1_1=2&ages1_2=2&ages1_3=2&seladults2=1&children2=0&ages2_1=2&ages2_2=2&ages2_3=2&lphopt1=0&lphopt2=0&CarCity=&CarCity-suggest=&calPickupDate=23+Jul+12&selPickupTime=12&selPickupMin=00&calDropOffDate=&selDropOffTime=12&selDropOffMin=00&lpcopt1=0&lpcopt2=0&rmdetails=1A&lphcityName=&lphcity=&lpccityName=&lpcsdate=&lpcedate=&lpccity=&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl14%24hdnSlideOmnitureEnabledLP=True&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl14%24hdnSlideOmnitureTimeSpendLP=1000&lastname2=&bookref2=&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl21%24hdnSlideOmnitureEnabledMB=True&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl21%24hdnSlideOmnitureTimeSpendMB=1000&lastname=&bookref=&seldcity2=&flightno=&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl28%24hdnSlideOmnitureEnabledOC=True&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl28%24hdnSlideOmnitureTimeSpendOC=1000&FSSearchBy=FSFlightNumber&txtFSFlightNumber=&ddlFSDepartureAirport=&ddlFSDepartureAirport-suggest=Departure+Airport&ddlFSArrivalAirport=&ddlFSArrivalAirport-suggest=Arrival+Airport&ddlFSDepartureDate=23-Jul-2012&FSArrivalDeparture=FSDeparture&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl35%24hdnSlideOmnitureEnabledFStatus=True&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl35%24hdnSlideOmnitureTimeSpendFStatus=1000&SFSearchBy=rbSFFlightNumber&txtSFFlightNumber=&ddlSFDepartureAirport=&ddlSFDepartureAirport-suggest=Departure+Airport&ddlSFArrivalAirport=&ddlSFArrivalAirport-suggest=Arrival+Airport&calSFDeparture=23+Jul+12&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl42%24hdnSlideOmnitureEnabledSF=True&ctl00%24MainContent%24ctl01%24ctl00%24ctl00%24ctl42%24hdnSlideOmnitureTimeSpendSF=1000&HttpsMode=true&NewHomePage=true&panelOpen=slideFlightSearch&LoginClick=&currentPanelOpen=slideFlightSearch"
      puts post_data
      File.write "em_post_#{price_type}", post_data

      command = "curl --cookie log/em_cookie --cookie-jar log/em_cookie --location 'http://fly4.emirates.com/CAB/SessionHandler.aspx?target=%2fIBE.aspx&pub=%2fus%2fenglish&s=boolSignOn%7cfalse%7cSME_AUTH%7csme-guest&h=505e4a529d529fa84cce4a4bf7c1fdb496f87d8&ibe=&FlexOnly=false' --data '@em_post_#{price_type}' > '#{file_name(price_request, price_type)}'"
      puts command
      `#{command}`
    end

    def parse price_request
      [ parse_from_file(price_request, "onward"),
        parse_from_file(price_request, "return"),
        parse_from_file(price_request, "total") ]
    end

    def parse_from_file price_request, price_type
      doc = Nokogiri::HTML(open(file_name(price_request, price_type)))
      price = doc.css('span.price').text.strip.gsub(/[^\d.]/, '').to_f
      price
    rescue => e
      Rails.logger.error "Error occurred while fetching prices - " + price_request.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      -1
    end

    def file_name price_request, price_type
      "log/#{price_request.request_hash}_#{price_type}"
    end

    def date_string date
      date.strftime "%d+%m+%y"
    end

    def date_string_2 date
      date.strftime "%d%m%Y"
    end

    def date_string_3 date
      date.strftime "%d+%b+%y"
    end

    def travel_class_string travel_class
      travel_class.downcase == "economy" ? "0" : "1"
    end

  end
end