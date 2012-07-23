module PriceScraper

  class EtPriceScraper

    @@not_available_prices = [-1, -1, -1, -1, -1, -1]

    def scrape price_request
      curl_url price_request
      prices = parse price_request

      price_request_eco = price_request.clone; price_request_eco.travel_class = "economy"
      price_request_bus = price_request.clone; price_request_bus.travel_class = "business"
      [Price.get_price_object(price_request_eco.request_hash, prices[0], prices[1], prices[2]),
       Price.get_price_object(price_request_bus.request_hash, prices[3], prices[4], prices[5])]
    end

    def curl_url price_request
      `rm log/et_cookie.file`
      `curl --cookie log/et_cookie.file --cookie-jar log/et_cookie.file --location 'http://www.flyethiopian.com/en/default.aspx' > /dev/null`

      curl_command = "curl --cookie log/et_cookie.file --cookie-jar log/et_cookie.file --location 'http://www.flyethiopian.com/en/booking/book.aspx' --data 'depYear=#{date_string(price_request.onward_date)}&depMonth=#{month_string(price_request.onward_date)}&depDay=#{day_string(price_request.onward_date)}&retYear=#{date_string(price_request.return_date)}&retMonth=#{month_string(price_request.return_date)}&retDay=#{day_string(price_request.return_date)}&journeySpan=RT&departCity=#{price_request.origin}&departureTime=#{date_string(price_request.onward_date)}&returnCity=#{price_request.destination}&returnTime=#{price_request.return_date}&cabin=#{price_request.travel_class.upcase}&numAdults=1&numChildren=0&numInfants=0&promoCode=&x=23&y=13' > '#{dump_file_path(price_request)}'"
      Rails.logger.info "Curling  : #{curl_command}"
      `#{curl_command}`
    end

    def parse price_request
      doc = Nokogiri::HTML(open(dump_file_path(price_request)))

      begin
        onward_economy_price = doc.css('td.price[id*="outbounds-E"] > em').map(&:text).map(&:strip).map(&:to_f).min
        return_economy_price = doc.css('td.price[id*="inbounds-E"] > em').map(&:text).map(&:strip).map(&:to_f).min
        total_economy_price = get_total_price onward_economy_price, return_economy_price
      rescue => e
        Rails.logger.error "Error occurred while fetching prices - " + price_request.inspect
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join "\n"
        onward_economy_price = return_economy_price = total_economy_price = -1
      end

      begin
        onward_business_price = doc.css('td.price[id*="outbounds-C"] > em').map(&:text).map(&:strip).map(&:to_f).min
        return_business_price = doc.css('td.price[id*="inbounds-C"] > em').map(&:text).map(&:strip).map(&:to_f).min
        total_business_price = get_total_price onward_business_price, return_business_price
      rescue => e
        Rails.logger.error "Error occurred while fetching prices - " + price_request.inspect
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join "\n"
        onward_business_price = return_business_price = total_business_price = -1
      end

      currency = doc.css('td.price[id*="outbounds"] > span.currency').map(&:text).map(&:strip).first

      prices = [ onward_economy_price, return_economy_price, total_economy_price,
       onward_business_price, return_business_price, total_business_price ]
      prices.map do | price| CurrencyMapper::CurrencyMapper.map_to_usd(currency, price) end
    end

    def get_total_price price1, price2
      return -1 if [price1, price2].include? nil
      price1 + price2
    end

    def dump_file_path price_request
      "log/#{price_request.request_hash}"
    end

    def date_string date
      date.strftime("%m-%d-%Y").gsub("-", "%2F")
    end

    def month_string date
      date.strftime("%b").upcase
    end

    def day_string date
      date.strftime("%d")
    end

  end

end