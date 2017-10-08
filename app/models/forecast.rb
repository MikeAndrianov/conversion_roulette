class Forecast < ApplicationRecord
  SUPPORTED_CURRENCIES = %w[AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR USD].freeze

  belongs_to :user

  before_save :set_interval

  validates :currency, :target_currency, :amount, :max_waiting_time, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :max_waiting_time, numericality: { only_integer: true, greater_than: 0 }
  validates :currency, :target_currency, inclusion: { in: SUPPORTED_CURRENCIES }
  validates :currency, exclusion: { in: ->(forecast) { [forecast.target_currency] } }
  validates :date_from, date: { before: :date_to, allow_blank: true }
  validates :date_from, date: { after: proc { Time.zone.today }, allow_blank: true }

  private

  def set_interval
    self.date_from = Time.zone.today + 1.day
    self.date_to = date_from + max_waiting_time.weeks
  end
end
