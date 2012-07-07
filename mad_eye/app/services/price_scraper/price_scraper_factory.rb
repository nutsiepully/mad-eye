require "price_scraper/price_scraper"

module PriceScraper
  class PriceScraperFactory

    @@price_scrapers = {
        :TEST => TestPriceScraper.new,
        :TAAG => TaagPriceScraper.new,
        :TAP => TapPriceScraper.new,
        :SA => PriceScraper.new,
        :EK => PriceScraper.new,
        :ET => PriceScraper.new,
        :KQ => PriceScraper.new
    }

    def self.get airline
      @@price_scrapers[airline.upcase.to_sym]
    end

  end
end
