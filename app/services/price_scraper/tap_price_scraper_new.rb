require 'json'

module PriceScraper
  class TapPriceScraperNew

    @@not_available_prices = [-1, -1, -1, -1, -1, -1]
    
    def scrape price_request
      @price_request = price_request.clone
      @price_request.travel_class = "economy"
      @price_request_ex = price_request.clone
      @price_request_ex.travel_class = "business"

      curl_url
      prices = parse

      [Price.get_price_object(@price_request.request_hash, prices[0], prices[1], prices[2]),
       Price.get_price_object(@price_request_ex.request_hash, prices[3], prices[4], prices[5])]
    end

    private

    def parse
      str = File.read(dump_file_path)

      out_flight_str = /var outboundLegs.*?var inbound/m.match(str)[0][18..-13]
      out_flight_json = JSON.parse(out_flight_str)
      out_flight_economy = out_flight_json.map { |elem| elem["Prices"].map { |elem| elem["Price"] }[0..-2] }.flatten.delete_if { |x| x.blank? }.min
      out_flight_business = out_flight_json.map { |elem| elem["Prices"].map { |elem| elem["Price"] }.last }.flatten.delete_if { |x| x.blank? }.min

      in_flight_str = /var inboundLegs.*?var request/m.match(str)[0][18..-13]
      in_flight_json = JSON.parse(in_flight_str)
      in_flight_economy = in_flight_json.map { |elem| elem["Prices"].map { |elem| elem["Price"] }[0..-2] }.flatten.delete_if { |x| x.blank? }.min
      in_flight_business = in_flight_json.map { |elem| elem["Prices"].map { |elem| elem["Price"] }.last }.flatten.delete_if { |x| x.blank? }.min

      out_flight_economy = out_flight_economy || -1
      out_flight_business = out_flight_business || -1
      in_flight_economy = in_flight_economy || -1
      in_flight_business = in_flight_business || -1

      [
        out_flight_economy, in_flight_economy, total(out_flight_economy, in_flight_economy),
        out_flight_business, in_flight_business, total(out_flight_business, in_flight_business)
      ]
    rescue => e
      Rails.logger.error "Error occurred while fetching prices - " + @price_request.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      @@not_available_prices
    end

    def total price1, price2
      return -1 if [ price1, price2 ].include? -1

      price1 + price2
    end

    def curl_url
      url = "http://book.flytap.com/r3air/TAPUS/PoweredAvailabilityBP.aspx?_a=FTUSEN&origin=#{@price_request.origin}&destination=#{@price_request.destination}&depDate=#{date_string(@price_request.onward_date)}&retDate=#{date_string(@price_request.return_date)}&depTime=0&retTime=0&flightType=Return&adt=1&_l=en-us&market=US&searchType=Fixed&selectedWeekend=1&pageTrace=4&price=0&"
      curl_command = "curl --location '#{url}' > #{dump_file_path}"
      
      Rails.logger.info "Curling  : #{curl_command}"
      puts "Curling : #{curl_command}"

      `#{curl_command}`
    end

    def date_string date
      # 02.01.2013
      date.strftime("%d.%m.%Y")
    end

    def dump_file_path #tailed with AIRORGDSTYYYYMMDDYYYYMMDD
      "log/#{self.class}_#{@price_request.request_hash.gsub("|", "").gsub("-", "")}"
    end

  end
end
