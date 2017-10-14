class CurrencyRate < ApplicationRecord
  SUPPORTED_CURRENCIES = %w[AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR USD].freeze

  validates :base, :date, :rates, presence: true
  validates :base, inclusion: { in: CurrencyRate::SUPPORTED_CURRENCIES }

  def self.dates_currencies_ratio(base_currency, target_currency, dates_range)
    where(base: base_currency, date: dates_range)
    .order(:date)
    .each_with_object({}) do |currency_rate, result|
      result[currency_rate.date] = currency_rate.rates[target_currency]
    end
  end

  def self.exchange_amounts(base_currency, target_currency, dates_range, amount)
    where(base: base_currency, date: dates_range)
    .order(:date)
    .each_with_object({}) do |currency_rate, result|
      result[currency_rate.date] = currency_rate.rates[target_currency] * amount
    end
  end

  def rate(forecast)
    rates[forecast.target_currency]
  end

  def exchanged_amount(forecast)
    rates[forecast.target_currency] * forecast.amount
  end
end
