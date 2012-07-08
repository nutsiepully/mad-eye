module PriceScraper
  class TapPriceScraper
    @@not_available_prices = [-1, -1, -1]

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
      [ Price.get_price_object(price_request.request_hash, prices[0], prices[1], prices[2])]
    end

    def parseNormal doc
      return doc.css('td.farePrice >table.innerCell').css('td > input[checked]').first.parent.parent.css('label').text.stripSpclChars.strip
    end

    def parseExecutive doc
      price3 = "9999999999999999999999999999999999999999"
      doc.css('tr').each do |eachRow|
        executiveField =  eachRow.css('td.farePrice > table.innerCell').last#.css('td > input')#.first.parent.parent.css('label').text.stripSpclChars.strip
        if(!executiveField.nil?)
          price_tmp = executiveField.css('td > input').first.parent.parent.css('label').text.stripSpclChars.strip
          price3 = compare(price3,price_tmp)
        end
      end
      return price3
    end

    private

    def parse
      doc = Nokogiri::HTML(open(dump_file_path))

      return @@not_available_prices if doc.css('div[@id="ctl00_Body_ErrorInfoBox_ErrorPanel"]').nil? ||
      doc.css('div[@id="ctl00_Body_ErrorInfoBox_ErrorPanel"]').empty?

      onward_price = strip_special_chars(parseNormal doc.css('table.ffTable').first)
      return_price = strip_special_chars(parseNormal doc.css('table.ffTable').last)
      final_price = (Float(price1))+(Float(price2))

      onward_price = convert_to_num_price onward_price
      return_price = convert_to_num_price return_price
      final_price = convert_to_num_price final_price

      [ onward_price, return_price, final_price ]
    rescue => e
      Rails.logger.error "Error occurred while fetching prices - " + @price_request.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      @@not_available_prices
      end

    def convert_to_num_price price_str
      price_str.gsub(/[^\d\.]/, '').to_f
    end

    def strip_special_chars str
      str.gsub(/[^0-9A-Za-z,. ]/, '')
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
