FactoryGirl.define do
  factory :forecast_currency_rate do
    forecast
    rate 1.2
    date Date.new(2020, 8, 20)
  end
end
