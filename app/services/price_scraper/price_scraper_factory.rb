require "price_scraper/price_scraper"

module PriceScraper
  class PriceScraperFactory

    @@price_scrapers = {
        :TEST => TestPriceScraper.new,
        :TAAG => TaagPriceScraper.new,
        :TAPOLD => TapPriceScraper.new,
        :TAP => TapPriceScraperNew.new,
        :SA => SaPriceScraper.new,
        :EK => EkPriceScraper.new,
        :ET => EtPriceScraper.new,
        :KQ => KqPriceScraper.new
    }

    def self.get airline
      #return TestPriceScraper.new
      @@price_scrapers[airline.upcase.to_sym]
    end

  end
end
