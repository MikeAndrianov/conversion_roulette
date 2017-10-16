class ForecastCurrencyRate < ApplicationRecord
  belongs_to :forecast

  delegate :currency, :target_currency, to: :forecast

  def exchanged_amount
    rate * forecast.amount
  end
end
