
require 'watir-webdriver'
require 'headless'

module PriceScraper
  class KqPriceScraper

    def scrape price_request
			increment_try_count
      prices = [ -1, -1, -1 ]

      begin
        prices = [ "onward", "return", "total" ].map { |trip_type| fetch_price(price_request, trip_type) }
      rescue => e
        Rails.logger.error "Error occurred while fetching prices - " + price_request.inspect
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join "\n"
      end

			if prices_are_wrong(prices)
				if @try_count < 2
					return scrape price_request
				else
					prices = [ -1, -1, -1 ]
				end
			end

      [ Price.get_price_object(price_request.request_hash, prices[0], prices[1], prices[2]) ]
    end

		def increment_try_count
			@try_count = @try_count || 0
			@try_count = @try_count + 1
		end

		def prices_are_wrong(prices)
			return true if (prices[2] != -1 && (prices[0] == -1 || prices[1] == -1))
			return true if (prices[0] != -1 && prices[1] != -1 && prices[2] == -1)

			false
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

      headless = Headless.new
      headless.start
      browser = Watir::Browser.new

      browser.goto "http://www.kenya-airways.com/default_en.aspx"

      one_way = trip_type != "total"

      if !one_way
        browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_0').set
      else
        browser.radio(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_rblBooking_1').set
        sleep(30)
      end

      browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstFrom').select_value(origin_string(price_request, trip_type))
      browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstTo').select_value(destination_string(price_request, trip_type))

      browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtDepartureDate').set(from_date_string(price_request, trip_type))
      if (!one_way)
        browser.text_field(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_txtReturnDate').set(date_string(price_request.return_date))
      end

      browser.select(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_lstCabinClass').select_value(travel_class_string(price_request.travel_class))

      browser.button(:id => 'ctl00_cph_flightsearch_pagekqbookingengine_cmdGo').click

      browser.frame.wait_until_present

      if !one_way
        price_text = browser.frame.td(:id => 'cell_3_3').text
      else
        price_text = browser.frame.td(:id => 'cell_3_0').text
      end

			puts "Fetched price text : " + price_text

      price = price_text == "sold out" ? -1 : price_text.gsub(/[^\d\.]/, '').to_f

      price

    #rescue Timeout::Error => te
    #  return fetch_price(price_request, trip_type)
    rescue => e
      Rails.logger.error "Error occurred while fetching prices - " + price_request.inspect + " - " + trip_type.inspect
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join "\n"
      browser.close
      headless.destroy
      -1
    end

  end
end
