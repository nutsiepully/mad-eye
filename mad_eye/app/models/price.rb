
class Price < ActiveRecord::Base

  def find_valid_price_for_hash hash
    find " :hash = #{hash} and updated_at"
  end

end
