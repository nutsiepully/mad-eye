
require 'watir-webdriver'
require 'headless'

module PriceScraper
  class KqPriceScraper

    def scrape price_request
      begin
				puts "Creating browser"
        @headless = Headless.new
        @headless.start
        @browser = Watir::Browser.new
				puts "Created browser"

        #prices = [ "total", "total", "total" ].map { |trip_type| fetch_price(price_request, trip_type) }
        prices = [ "onward", "return", "total" ].map { |trip_type| fetch_price(price_request, trip_type) }

				puts "Fetched prices"

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
    	puts "Fetching prices for price type " + trip_type
      @browser.goto "http://www.kenya-airways.com/default_en.aspx"
			puts "Moving to home page"

      if trip_type == "total"
        @browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_0').set
      else
        @browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_1').set
				Watir::Wait.until { @browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_1').checked? }
				#sleep(30)
      end

      @browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstFrom').when_present
              .select_value(origin_string(price_request, trip_type))
      @browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstTo').when_present
              .select_value(destination_string(price_request, trip_type))

      @browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtDepartureDate').when_present
              .set(from_date_string(price_request, trip_type))
      if trip_type == "total"
        @browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtReturnDate').when_present
              .set(date_string(price_request.return_date))
      end

      #@browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstCabinClass').when_present
      @browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstCabinClass').when_present
              .select_value(travel_class_string(price_request.travel_class))

      @browser.button(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_cmdGo').when_present.click
      #@browser.button(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_cmdGo').click

			puts "Clicked and moved to pricing page"

      @browser.frame().wait_until_present

      price_text = trip_type == "total" \
            ? @browser.frame().td(:id => 'cell_3_3').text \
            : @browser.frame().td(:id => 'cell_3_0').text

			puts "Fetched price text : " + price_text

      price = price_text == "sold out" ? -1 : price_text.gsub(/[^\d\.]/, '').to_f

      price
    #rescue Timeout::Error => te
    #  return fetch_price(price_request, trip_type)
    rescue => e
      Rails.logger.error "Error occurred while fetching prices - " + price_request.inspect + " - " + trip_type.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      -1
    end

  end
end
