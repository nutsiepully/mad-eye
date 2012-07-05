
class AirpriceController < ApplicationController

	def get
    logger.info "In controller"
		logger.info params.to_s

    main_airline = params["main_airline"]
    competitor_airline = params["competitor_airline"]
    origin = params["origin"]
    destination = params["destination"]
    onward_date_str = params["onward_date"]
    return_date_str = params["return_date"]

    request_main_airline = PriceRequest.new main_airline, origin, destination, onward_date_str, return_date_str, :economy
    request_main_airline = PriceRequest.new main_airline, origin, destination, onward_date_str, return_date_str, :business
    request_competitor_airline = PriceRequest.new main_airline, origin, destination, onward_date_str, return_date_str,

    @ret = '100,100,200,200,200,450,90,90,200,150,150,350'
	end

end
