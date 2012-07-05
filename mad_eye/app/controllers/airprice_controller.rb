
class AirpriceController < ApplicationController

  rescue_from StandardError do |error|
    logger.error error.message
    logger.error error.backtrace
    render :nothing => "ERROR : #{error}", :status => 200
  end

  @@dummy = '100,100,200,200,200,450,90,90,200,150,150,350'

	def get
    if params.include? "test"
      @result = @@dummy
      return
    end

    main_airline       = params["main_airline"]
    competitor_airline = params["competitor_airline"]
    origin             = params["origin"]
    destination        = params["destination"]
    onward_date_str    = params["onward_date"]
    return_date_str    = params["return_date"]

    request_main_airline_economy =
        PriceRequest.new main_airline, origin, destination, onward_date_str, return_date_str, :economy
    request_main_airline_business =
        PriceRequest.new main_airline, origin, destination, onward_date_str, return_date_str, :business
    request_competitor_airline_economy =
        PriceRequest.new competitor_airline, origin, destination, onward_date_str, return_date_str, :economy
    request_competitor_airline_business =
        PriceRequest.new competitor_airline, origin, destination, onward_date_str, return_date_str, :business

    price_main_airline_economy = PriceFinder.find_for request_main_airline_economy
    price_main_airline_business = PriceFinder.find_for request_main_airline_business
    price_competitor_airline_economy = PriceFinder.find_for request_competitor_airline_economy
    price_competitor_airline_business = PriceFinder.find_for request_competitor_airline_business

    @result = price_main_airline_economy.to_s + "," + price_main_airline_business.to_s + "," +
        price_competitor_airline_economy + "," + price_competitor_airline_business
	end

end
