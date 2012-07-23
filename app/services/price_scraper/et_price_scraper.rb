module PriceScraper

  class EtPriceScraper

    @@not_available_prices = [-1, -1, -1]

    def scrape price_request
      curl_url price_request
      prices = parse
      [Price.get_price_object(price_request.request_hash, prices[0], prices[1], prices[2])]
    end

    def curl_url price_request
      `rm log/cookie.file`
      `curl --cookie log/et_cookie.file --cookie-jar log/et_cookie.file --location 'http://www.flyethiopian.com/en/default.aspx' > /dev/null`

      Rails.logger.info "Curling  : #{curl_command}"
      curl_command = "curl --dump-header #{dump_header_path} --cookie log/et_cookie.file --cookie-jar log/et_cookie.file --location 'http://www.flyethiopian.com/en/booking/book.aspx' --data 'depYear=#{date_string(price_request.onward_date)}&depMonth=#{month_string(price_request.onward_date)}&depDay=#{day_string(price_request.onward_date)}&retYear=#{date_string(price_request.return_date)}&retMonth=#{month_string(price_request.return_date)}&retDay=#{day_string(price_request.return_date)}&journeySpan=RT&departCity=#{price_request.origin}&departureTime=#{date_string(price_request.onward_date)}&returnCity=#{price_request.destination}&returnTime=#{price_request.return_date}&cabin=#{price_request.travel_class.upcase}&numAdults=1&numChildren=0&numInfants=0&promoCode=&x=23&y=13' > #{dump_file_path}"
      `#{curl_command}`
    end

    def parse
      doc = Nokogiri::HTML(open(dump_file_path))


    rescue => e
      Rails.logger.error "Error occurred while fetching prices - " + @price_request.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      @@not_available_prices
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