
class PriceScraperFactory

  @@price_scrapers = {
      :TAAG => TaagPriceScraper.new,
      :TAP => TapPriceScraper.new
  }

  def self.get airline
    @@price_scrapers[airline.upcase.to_sym]
  end

end