module PriceScraper
  class TapPriceScraper
    @@not_available_prices = [-1, -1, -1, -1, -1, -1]

    @@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.43 Safari/536.11"

    @@headers = [
        "Accept-Language: en-US,en;q=0.8",
        "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
    ]

    def scrape price_request
      @price_request = price_request
      url = form_url price_request
      curl_url url
      prices = parse
      price_request.travel_class = "economy"
      @price_request_ex = price_request.clone
      @price_request_ex.travel_class = "business"

      [ Price.get_price_object(price_request.request_hash, prices[0], prices[1], prices[2]),
       Price.get_price_object(@price_request_ex.request_hash, prices[3], prices[4], prices[5]) ]
    end

    def parse_normal doc
      return strip_special_chars(doc.css('td.farePrice >table.innerCell').css('td > input[checked]').first.parent.parent.css('label').text)
    end

    def parse_executive doc
      low_price = nil
      doc.css('tr').each do |eachRow|
        executiveField = eachRow.css('td.farePrice > table.innerCell').last
        if (!executiveField.nil?)
          price_tmp = strip_special_chars(executiveField.css('td > input').first.parent.parent.css('label').text)
          if low_price.nil?
            low_price = price_tmp
          else
            low_price = get_lower(low_price, price_tmp)
          end
        end
      end
      return low_price
    end

    private

    def parse
      doc = Nokogiri::HTML(open(dump_file_path))

      if (!doc.css('div[@id="ctl00_Body_ErrorInfoBox_ErrorPanel"]').nil?)
        return @@not_available_prices if !doc.css('div[@id="ctl00_Body_ErrorInfoBox_ErrorPanel"]').empty?
      end

      onward_price = strip_special_chars(parse_normal(doc.css('table.ffTable').first))
      return_price = strip_special_chars(parse_normal(doc.css('table.ffTable').last))
      final_price = (Float(onward_price))+(Float(return_price))

      onward_price_ex = strip_special_chars(parse_executive(doc.css('table.ffTable').first))
      return_price_ex = strip_special_chars(parse_executive(doc.css('table.ffTable').last))
      final_price_ex = (Float(onward_price_ex))+(Float(return_price_ex))

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

    def get_lower(price1, price2)
      return convert_to_num_price(price1)>convert_to_num_price(price2) ? price2 : price1
    end

    def convert_to_num_price price_str
      price_str.gsub(/[^\d\.]/, '').to_f
    end

    def strip_special_chars str
      str.gsub(/[^0-9A-Za-z,. ]/, '').strip
    end

    def dump_file_path
      "log/#{self.class}"
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
      "http://book.flytap.com/r3air/TAPUS/PoweredAvailabilityBP.aspx?milesRedemption=false&origin=#{price_request.destination}&destination=#{price_request.origin}&flightType=Return&depDate=#{date_string(price_request.onward_date)}&retDate=#{date_string(price_request.return_date)}&cabinClass=Y&ccSearch=P&adt=1&depTime=0&retTime=0&pageTrace=4|4&requestID=5033212708562627635&_a=FTUSEN&_l=en-us&market=US&maxConn=-1"
    end

    def date_string date
      date.strftime "%d.%m.%Y"
    end
  end
end
