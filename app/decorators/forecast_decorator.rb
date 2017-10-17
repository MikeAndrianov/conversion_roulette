class ForecastDecorator < SimpleDelegator
  def currency_rates_from_beginning_of_week
    (currency_rates_for_fulling_first_week_days + forecast_currency_rates).each_with_object([]) do |currency_rate, res|
      rate, amount = if currency_rate.is_a?(CurrencyRate)
                       [currency_rate.rate(self), currency_rate.exchanged_amount(self)]
                     else
                       [currency_rate.rate, currency_rate.exchanged_amount]
                     end

      res << OpenStruct.new(
        rate: rate,
        amount: amount,
        date: currency_rate.date,
        profit: amount - amount_for_day_before_forecast
      )
    end
  end

  private

  def currency_rates_for_fulling_first_week_days
    @currency_rates_for_filling ||= CurrencyRate.where(
      base: currency,
      date: date_from.beginning_of_week...date_from
    ).order(:date)
  end

  def amount_for_day_before_forecast
    last_currency_rate = currency_rates_for_fulling_first_week_days.last

    last_currency_rate ? last_currency_rate.exchanged_amount(self) : 0
  end
end
