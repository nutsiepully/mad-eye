class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :code
      t.string :name
      t.float :usd_conversion
      t.timestamps
    end
  end
end
