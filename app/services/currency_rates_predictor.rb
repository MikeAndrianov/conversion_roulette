class CurrencyRatesPredictor
  # TODO: Add cloud.google.com/prediction
  PREDICTION_ADAPTERS = {
    simple_linear_regression: LinearRegressionAdapter
  }.freeze

  def initialize(forecast, currency_rates, adapter = :simple_linear_regression)
    @forecast = forecast
    @currency_rates = currency_rates
    @adapter_class = PREDICTION_ADAPTERS[adapter]
  end

  def perform
    adapter = @adapter_class.new(training_data.keys, training_data.values)

    create_forecast_currency_rates(adapter)
  end

  private

  def training_data
    @training_data ||= @currency_rates.each_with_object({}) do |currency_rate, result|
      result[currency_rate.rates[@forecast.target_currency]] = unix_timestamp(currency_rate.date)
    end
  end

  def create_forecast_currency_rates(adapter)
    ActiveRecord::Base.transaction do
      @forecast.dates_range.each do |date|
        predicted_rate = adapter.predict(unix_timestamp(date))
        @forecast.forecast_currency_rates.create(date: date, rate: predicted_rate)
      end

      @forecast.to_completed!
    end
  end

  def unix_timestamp(date)
    date.to_time.to_i
  end
end
