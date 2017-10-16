class CreateForecastCurrencyRates < ActiveRecord::Migration[5.1]
  def change
    create_table :forecast_currency_rates do |t|
      t.date :date
      t.float :rate
      t.references :forecast, foreign_key: true

      t.timestamps
    end
  end
end
