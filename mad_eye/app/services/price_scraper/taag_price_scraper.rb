
module PriceScraper

  class String
    def strip_special_chars
      self.gsub(/[^0-9A-Za-z,. ]/, '')
    end
  end

  class TaagPriceScraper

    @@user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.43 Safari/536.11"

    @@headers = [
        "Accept-Language: en-US,en;q=0.8",
        "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3"
    ]

    def scrape price_request
      url = form_url price_request
      curl_url url
      prices = parse
      Price.get_price_object price_request.request_hash, prices[0], prices[1], prices[2]
    end

    private

    def parse
      doc = Nokogiri::HTML(open(dump_file_path))

      return [-1, -1, -1] if doc.css('span.error').nil? && doc.css('img.errorimage').nil?

      onward_price = doc.css('td > div[@id = "jnytar1"]').first.css('td.headlineonewayprice > input[checked = "checked"].radio').first.parent.css('a').text.strip_special_chars
      return_price = doc.css('td > div[@id = "jnytar2"]').first.css('td.headlineonewayprice > input[checked = "checked"].radio').first.parent.css('a').text.strip_special_chars
      final_price = doc.css('td.totalled').css('div[style = "display:inline"].totalreturnprice').text.slice(/:.*/).strip.gsub(/:/, "").strip_special_chars
      [ onward_price, return_price, final_price ]
    end

    def header_command_string
      " " + @@headers.map { |header| "--header '#{header}'" }.join(" ") + " "
    end

    def curl_url url, data = ''
      curl_command = "curl --dump-header #{dump_header_path} --cookie log/cookie.file --cookie-jar log/cookie.file #{header_command_string} --user-agent '#{@@user_agent}' --location '#{url}' > #{dump_file_path}"
      puts "Curling  : #{curl_command}"
      Rails.logger.info "Curling  : #{curl_command}"

      `rm cookie.file`
      `#{curl_command}`
    end

    def dump_file_path
      "log/#{self.class}"
    end

    def dump_header_path
      "log/#{self.class}_header"
    end

    def form_url price_request
      "https://taag.sita.aero/itd/itd/DoAirSearch?_destinationSelected=Airport.#{price_request.destination}&_originSelected=Airport.#{price_request.origin}&_adults=1&_children=0&_infants=0&_depdateeu=#{date_string(price_request.onward_date)}&_retdateeu=#{date_string(price_request.return_date)}&_classType=#{travel_class_string(price_request.travel_class)}&requestor=AirSimpleReqs&_channelLocale=en"
    end

    def date_string date
      date.strftime "%d/%m/%Y"
    end

    def travel_class_string travel_class
      travel_class.capitalize
    end

  end
end