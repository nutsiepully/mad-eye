require "test_helper"

class PriceRequestTest < ActiveSupport::TestCase

  test "should create price request correctly" do

    price_request = PriceRequest.new "TAAG", "LAD", "LIS", "2012-05-05", "2012-07-07", :economy

    assert price_request.airline == "TAAG"
    assert price_request.origin == "LAD"
    assert price_request.destination == "LIS"
    assert price_request.onward_date == DateTime.new(2012, 5, 5)
    assert price_request.return_date == DateTime.new(2012, 7, 7)
    assert price_request.travel_class == :economy
  end

end