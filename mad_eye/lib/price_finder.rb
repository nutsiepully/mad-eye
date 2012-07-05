class PriceFinder

  def self.find_for price_request
    price = Price.find_valid_price_for_hash price_request.request_hash
    return price if not price.nil?

    price_scraper = PriceScraperFactory.get_scraper price_request.airline
    prices = price_scraper.scrape price_request

    prices.each do  | price | price.save! end

    prices.find do | price | price.hash == price_request.hash end
  end

end
