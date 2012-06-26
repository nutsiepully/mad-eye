
# Class that encapsulates the price for a particular flight
class Price
	attr_accessor :category
	attr_accessor :currency
	attr_accessor :price

	def initialize p_category, p_currency, p_price
		@category = p_category
		@currency = p_currency
		if p_price.is_a? String
			@price = p_price.gsub(/,/, "").to_f
		elsif p_price.is_a? Fixnum or p_price.is_a? Float
			@price = p_price.to_f
		else
			raise StandardError.new
		end
	end

	def to_s
		"{ Category = #{@category}, Currency = #{@currency}, Price = #{@price} }"
	end
end

