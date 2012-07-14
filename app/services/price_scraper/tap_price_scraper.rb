module PriceScraper
  class TapPriceScraper
    @@not_available_prices = [-1, -1, -1, -1, -1, -1]

    @@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.43 Safari/536.11"

    @@headers = [
        "Accept-Language: en-US,en;q=0.8",
        "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
    ]

    def scrape price_request
      @price_request = price_request.clone
      url = form_url price_request
      curl_url url
      prices = parse
      @price_request.travel_class = "economy"
      @price_request_ex = price_request.clone
      @price_request_ex.travel_class = "business"

      [Price.get_price_object(@price_request.request_hash, prices[0], prices[1], prices[2]),
       Price.get_price_object(@price_request_ex.request_hash, prices[3], prices[4], prices[5])]
    end

    def parse_error doc
      if (!doc.css('div[@id="ctl00_Body_ErrorInfoBox_ErrorPanel"]').nil?)
        return false if !doc.css('div[@id="ctl00_Body_ErrorInfoBox_ErrorPanel"]').empty?
      end
      return false if (doc.css('td.farePrice').nil? || doc.css('td.farePrice').empty?)
      Rails.logger.debug "Will look for the prices"
      return true
    end

    def parse_normal doc
      #put in logic to not to return executive
      all_fare_prices = doc.css('td.farePrice')
      all_fare_prices.each do |farePrice|
        next if (((all_fare_prices.index(farePrice) +1)% 5) == 0) #next if executive
        next if (farePrice.css('td > input[checked]').nil? || farePrice.css('td > input[checked]').empty?)
        return strip_special_chars(farePrice.css('td > input[checked]').first.parent.parent.css('label').text)
      end
      #return strip_special_chars(doc.css('td.farePrice >table.innerCell').css('td > input[checked]').first.parent.parent.css('label').text)
      return nil
    end

    def parse_executive doc
      low_price = nil
      doc.css('tr').each do |eachRow|
        executiveField = eachRow.css('td.farePrice').last #Only the last column is executive
        next if (executiveField.nil?)
        next if (!executiveField.css('div.availBP').nil? && !executiveField.css('div.availBP').empty?)
        executiveField = executiveField.css('table.innerCell')
        if (!executiveField.nil?)
          price_tmp = strip_special_chars(executiveField.css('td > input').first.parent.parent.css('label').text)
          low_price = price_tmp if (low_price.nil?)
          low_price = get_lower(low_price, price_tmp)
        end
      end
      return low_price
    end

    private

    def parse
      doc = Nokogiri::HTML(open(dump_file_path))

      return @@not_available_prices if !parse_error(doc)

      onward_price = strip_special_chars(parse_normal(doc.css('table.ffTable').first))
      return_price = strip_special_chars(parse_normal(doc.css('table.ffTable').last))
      final_price = total_price(convert_to_num_price(onward_price), convert_to_num_price(return_price))

      onward_price_ex = strip_special_chars(parse_executive(doc.css('table.ffTable').first))
      return_price_ex = strip_special_chars(parse_executive(doc.css('table.ffTable').last))
      final_price_ex = total_price(convert_to_num_price(onward_price_ex), convert_to_num_price(return_price_ex))

      onward_price = convert_to_num_price(onward_price)
      return_price = convert_to_num_price(return_price)

      onward_price_ex = convert_to_num_price(onward_price_ex)
      return_price_ex = convert_to_num_price(return_price_ex)

      [onward_price, return_price, final_price, onward_price_ex, return_price_ex, final_price_ex]

    rescue => e
      Rails.logger.error "Error occurred while fetching prices - " + @price_request.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      @@not_available_prices
    end

    #things below will go in an abstract class.
    def get_lower(price1, price2)
      return convert_to_num_price(price1)>convert_to_num_price(price2) ? price2 : price1
    end

    def convert_to_num_price price_str
      if price_str.nil?
        return -1
      end
      price_str.gsub(/[^\d\.]/, '').to_f
    end

    def strip_special_chars str
      unless str.nil?
        str.gsub(/[^0-9A-Za-z,. ]/, '').strip
      end
    end

    def total_price(price1, price2)
      return -1 if (price1 < 0 || price2 < 0)
      total = price1+price2
      total
    end

    def dump_file_path #tailed with AIRORGDSTYYYYMMDDYYYYMMDD
      "log/#{self.class}_#{@price_request.request_hash.gsub("|", "").gsub("-", "")}"
    end

    def dump_header_path
      "log/#{self.class}_header"
    end

    def header_command_string
      " " + @@headers.map { |header| "--header '#{header}'" }.join(" ") + " "
    end

    def curl_url url, data = ''
      curl_command = "curl --dump-header #{dump_header_path} --cookie log/cookie.file --cookie-jar log/cookie.file #{header_command_string} --user-agent '#{@@user_agent}' --location '#{url}' > #{dump_file_path}"
      puts "Curling  : #{curl_command}"
      Rails.logger.info "Curling  : #{curl_command}"

      `rm log/cookie.file`
      `#{curl_command}`
    end

    def form_url price_request
      "http://book.flytap.com/r3air/TAPUS/PoweredAvailabilityBP.aspx?milesRedemption=false&origin=#{price_request.origin}&destination=#{price_request.destination}&flightType=Return&depDate=#{date_string(price_request.onward_date)}&retDate=#{date_string(price_request.return_date)}&cabinClass=Y&ccSearch=P&adt=1&depTime=0&retTime=0&pageTrace=4|4&requestID=5033212708562627635&_a=FTUSEN&_l=en-us&market=US&maxConn=-1"
    end

    def date_string date
      date.strftime "%d.%m.%Y"
    end
  end
end
