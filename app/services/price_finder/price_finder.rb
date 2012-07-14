module PriceFinder
  class PriceFinder

    def self.find_for price_request, no_cache = false
      if !no_cache
        price = Price.find_valid_price_for_hash price_request.request_hash
        return price if not price.nil?
      end

      price_scraper = PriceScraper::PriceScraperFactory.get price_request.airline
      prices = price_scraper.scrape price_request

      prices.each do |price|
        price.save!
      end

      prices.find do |price|
        price.context_hash == price_request.request_hash
      end
    end

  end
end