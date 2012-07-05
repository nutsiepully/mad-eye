class PriceFinder

  def find_for price_request
    price = Price.find_by_hash Util.hash(price_request)
    return price if not price.nil?

    price_scraper = PriceScraperFactory.get_scraper price_request.airline
    prices = price_scraper.scrape_price price_request
    prices.each do
      { | price| price.save!}

      prices.find
    end

  end
end


