
class Price < ActiveRecord::Base

  def self.get_price_object context_hash, onward_price, return_price, final_price
    price = Price.new do |price|
      price.context_hash = context_hash
      price.onward_price = onward_price
      price.return_price = return_price
      price.final_price = final_price
    end
    price
  end

  def self.find_valid_price_for_hash hash
    now = DateTime.now
    yesterday = now - 1
    self.where(" context_hash = '#{hash}' and updated_at >= '#{yesterday}' ").order("created_at DESC").first
  end

  def self.not_applicable_price hash
    get_price_object hash, -1, -1, -1
  end

  def to_s
    "#{wrap(onward_price)},#{wrap(return_price)},#{wrap(final_price)}"
  end

  private

  def wrap price
    price == -1 ? "NA" : price.to_s
  end

end
