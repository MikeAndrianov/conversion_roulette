class ForecastBuilder
  attr_reader :forecast

  def initialize(forecast)
    @forecast = forecast
  end

  def perform
    @forecast.to_processing!
    ForecastPredictionJob.perform_later(@forecast)
  end

  def rebuild
    @forecast.forecast_currency_rates.delete_all

    perform
  end
end
