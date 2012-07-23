
module CurrencyMapper
  class CurrencyMapper

    @@currency_map = nil

    private

    def self.get_currency_map
      return @@currency_map unless @@currency_map.blank?
      `curl http://openexchangerates.org/latest.json > currency_rates`
      currency_json = File.read 'currency_rates'
      @@currency_map = JSON.parse(currency_json)['rates']
    end


    public

    def self.map_to_usd input_currency, value
      return value if input_currency.blank? || input_currency.upcase == "USD" || value.blank? || value < 0.0

      value / get_currency_map[input_currency]
    end

  end
end