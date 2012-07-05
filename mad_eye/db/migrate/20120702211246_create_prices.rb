class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :hash
      t.float :onward_price
      t.float :return_price
      t.float :final_price
      t.timestamps
    end
  end
end
