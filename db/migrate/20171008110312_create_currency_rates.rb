class CreateCurrencyRates < ActiveRecord::Migration[5.1]
  def change
    create_table :currency_rates do |t|
      t.string :base, null: false
      t.date :date, null: false
      t.json :rates, null: false

      t.timestamps
    end
  end
end
