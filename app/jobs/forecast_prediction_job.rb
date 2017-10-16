class ForecastPredictionJob < ApplicationJob
  queue_as :default

  def perform(forecast)
    currency_rates = CurrencyRate.find_or_fetch(forecast.currency, forecast.previous_days_range)
    CurrencyRatesPredictor.new(forecast, currency_rates).perform
  rescue StandardError => e
    forecast.to_failed!

    raise e
  end
end
