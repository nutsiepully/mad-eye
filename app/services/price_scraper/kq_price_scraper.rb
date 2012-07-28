
require 'watir-webdriver'
require 'headless'

module PriceScraper
  class KqPriceScraper

    def scrape price_request
      begin
        @headless = Headless.new
        @headless.start
        @browser = Watir::Browser.new

        prices = [ "onward", "return", "total" ].map { |trip_type| fetch_price(price_request, trip_type) }

      rescue => e
        Rails.logger.error "Error occurred while fetching prices - " + price_request.inspect
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join "\n"
        prices = [ -1, -1, -1]
      ensure
        @browser.close
        @headless.destroy
      end
      [ Price.get_price_object(price_request.request_hash, prices[0], prices[1], prices[2]) ]
    end

    def origin_string price_request, trip_type
      trip_type != "return" ? price_request.origin : price_request.destination
    end

    def destination_string price_request, trip_type
      trip_type != "return" ? price_request.destination : price_request.origin
    end

    def from_date_string price_request, trip_type
      trip_type != "return" ? date_string(price_request.onward_date) : date_string(price_request.return_date)
    end

    def travel_class_string travel_class
      travel_class.to_s.downcase == "economy" ? "E" : "B"
    end

    def date_string date
      date.strftime "%d-%m-%Y"
    end

    def fetch_price price_request, trip_type
      @browser.goto "http://www.kenya-airways.com/default_en.aspx"

      if trip_type == "total"
        @browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_0').set
      else
        @browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_1').set
      end

      @browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstFrom')
              .select_value(origin_string(price_request, trip_type))
      @browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstTo')
              .select_value(destination_string(price_request, trip_type))

      @browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtDepartureDate')
              .set(from_date_string(price_request, trip_type))
      if trip_type == "total"
        @browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtReturnDate')
                .set(date_string(price_request.return_date))
      end

      @browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstCabinClass')
              .select_value(travel_class_string(price_request.travel_class))

      @browser.button(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_cmdGo').click

      @browser.frame().wait_until_present(180)

      price_text = trip_type == "total" \
            ? @browser.frame().td(:id => 'cell_3_3').text \
            : @browser.frame().td(:id => 'cell_3_0').text

      price = price_text == "sold out" ? -1 : price_text.gsub(/[^\d\.]/, '').to_f

      price
    rescue => e
      Rails.logger.error "Error occurred while fetching prices - " + price_request.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      -1
    end

  end
end