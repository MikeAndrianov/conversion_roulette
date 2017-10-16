class CurrencyRate < ApplicationRecord
  SUPPORTED_CURRENCIES = %w[AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR USD].freeze

  validates :base, :date, :rates, presence: true
  validates :base, inclusion: { in: CurrencyRate::SUPPORTED_CURRENCIES }

  def self.find_or_fetch(base_currency, dates_range)
    dates_range.map do |date|
      find_by(base: base_currency, date: date) || fetch(date, base_currency)
    end.compact
  end

  def self.fetch(date, currency)
    response = FixerApi::Client.get_rates_for_day(date, base: currency)
    return unless response

    create(response)
  end

  def rate(forecast)
    rates[forecast.target_currency]
  end

  def exchanged_amount(forecast)
    rate(forecast) * forecast.amount
  end
end
