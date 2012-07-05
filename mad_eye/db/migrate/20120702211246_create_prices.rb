class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :context_hash
      t.float :onward_price
      t.float :return_price
      t.float :final_price
      t.timestamps
    end

    add_index :prices, :context_hash
  end
end
