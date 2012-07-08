module PriceScraper
  class PriceScraper

  end

  class TestPriceScraper

    def scrape price_request
      reg_proc = Proc.new do |request|
        Price.get_price_object(request.request_hash, rand, rand, rand(400))
      end
      na_proc = Proc.new do |request|
        Price.get_price_object(request.request_hash, -1, -1, -1)
      end
      [ do_with_probability(80, reg_proc, na_proc, price_request) ]
    end

    private

    def rand seed = 100, range = 100
      seed + Random.rand(range)
    end

    def do_with_probability prob, proc1, proc2, price_request
      (Random.rand * 100) <= prob ? proc1.call(price_request) : proc2.call(price_request)
    end

  end

end