
module PriceScraper

  class SaPriceScraper

    def scrape price_request
      curl_url price_request
      prices = parse

      price_request_econ = price_request.clone
      price_request_econ.travel_class = "economy"
      price_request_exec = price_request.clone
      price_request_exec.travel_class = "business"
      [ Price.get_price_object(price_request_econ.request_hash, prices[0], prices[1], prices[2]),
        Price.get_price_object(price_request_exec.request_hash, prices[3], prices[4], prices[5]) ]
    end

    def curl_url price_request
      curl_command = "curl --dump-header #{dump_header_path} --cookie log/sa_cookie.file --cookie-jar log/sa_cookie.file --location 'http://www.flysaa.com/ao/en/flightSearch.action?request_locale=en_AO' --data 'selectedLang=EN&preferredClass=0&calendarSearchFlag=false&countrySeltd=IN&selectedProductIs=FTS&searchInput=Search&globalNoticeUrl=&localNoticeUrl=&country=AO&selLanguage=EN&voyagerNumber=&email=&mobileUser=false&departCity=#{price_request.origin}&destCity=#{price_request.destination}&departDay=#{day_string(price_request.onward_date)}&departMonthYear=#{month_year_string(price_request.onward_date)}&fromDate=#{date_string(price_request.onward_date)}&carHireDepMonthYear=#{month_year_string(price_request.onward_date)}&carHireDestMonthYear=#{month_year_string(price_request.return_date)}&chkReturn=on&tripType=R&destDay=#{day_string(price_request.return_date)}&returnMonthYear=#{month_year_string(price_request.return_date)}&toDate=#{date_string(price_request.return_date)}&flexible=false&adultPop=1&adultCount=1&childPop=0&childCount=0&infantPop=0&infantCount=0&flightClass=0&promoCode=&checkinDepartCity=&checkInMethod=PNR&FlightChecked=on&flightNumber=&departureCity=&destinationCity=&fromDateFLT=-1&pickupLoc=&txtpick_loc=&dropoffLoc=&txtdrop_loc=&pickDay=&pickMonthYear=&pickUpTime=0900&dropoffDay=&dropoffMonthYear=&dropOffTime=0900&carCountry=&txtcountry=' > #{dump_file_path}"
      Rails.logger.info "Curling  : #{curl_command}"

      #`rm log/cookie.file`
      `#{curl_command}`

      doc = Nokogiri::HTML(open(dump_file_path))
			is_tax_page = false
			begin
			is_tax_page = doc.css('div > span').text.start_with?("Click continue to view the cheapest flight combination for the dates chosen")
			rescue
			end

			return unless is_tax_page

			`curl --cookie log/sa_cookie.file --cookie-jar log/sa_cookie.file --location 'http://www.flysaa.com/ao/en/flightSearch!getTDPnoTaxAvailability.action' > #{dump_file_path}`
    end

    def parse
      doc = Nokogiri::HTML(open(dump_file_path))

      prices = [ get_price(doc, true, true), get_price(doc, false, true), 0.0,
        get_price(doc, true, false), get_price(doc, false, false), 0.0,
      ]
      prices[2] = (prices[0] != -1 && prices[1] != -1) ? prices[0] + prices[1] : -1
      prices[5] = (prices[3] != -1 && prices[4] != -1) ? prices[3] + prices[4] : -1

      prices
    end

    def get_price doc, onward, economy
      index = onward ? 0 : 1
      travel_class = economy ? 'economy' : 'business'
      price = doc.css('div.whiteOnBlue')[index].css("td.#{travel_class}Family > div").map(&:text).map(&:strip).delete_if { |s| s == "Sold Out" }.map { |s| s.gsub(/[^\d\.,]/, '') }.map(&:to_f).min
      price.nil? ? -1 : price
    rescue => e
      Rails.logger.error "Error occurred while fetching prices - "
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      -1
    end

    def dump_file_path
      "log/#{self.class}"
    end

    def dump_header_path
      "log/#{self.class}_header"
    end

    def day_string date
      date.strftime "%d"
    end

    def month_year_string date
      date.strftime "%b+%Y"
    end

    def date_string date
      date.strftime "%d-%b+%Y"
    end

  end

end
