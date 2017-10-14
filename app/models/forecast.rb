class Forecast < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :forecast_currency_rates

  before_save :set_interval

  validates :currency, :target_currency, :amount, :max_waiting_time, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :max_waiting_time, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 250 }
  validates :currency, :target_currency, inclusion: { in: CurrencyRate::SUPPORTED_CURRENCIES }
  validates :currency, exclusion: { in: ->(forecast) { [forecast.target_currency] } }
  validates :date_from, date: { before: :date_to, allow_blank: true }
  validates :date_from, date: { after: proc { Time.zone.today }, allow_blank: true }

  aasm column: :state do
    state :data_collecting, initial: true
    state :processing
    state :completed

    event :to_processing do
      transitions from: :data_collecting, to: :processing
    end

    event :to_completed do
      transitions from: :processing, to: :completed
    end
  end

  private

  def set_interval
    self.date_from = Time.zone.today + 1.day
    self.date_to = date_from + max_waiting_time.weeks
  end
end
