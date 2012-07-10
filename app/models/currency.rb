class Currency < ActiveRecord::Base
  # attr_accessible :title, :body

  attr_accessor :value

  def self.get_for currency_code, price_str
    currency = Currency.new do |currency|
      currency.code = currency_code
    end
    currency.value = get_value_from_str currency_code, price_str
    currency
  end

  private

  def self.get_value_from_str code, price_str
    proc = Proc.new do |str| str.gsub(/[^\d\.]/, '') end

    if code.to_sym == :EUR
      proc = Proc.new do |str| str.gsub(/[^\d,]/, '').gsub(',', '.') end
    end

    proc.call(price_str).to_f
  end

end