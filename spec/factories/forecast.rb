FactoryGirl.define do
  factory :forecast do
    user
    currency 'USD'
    target_currency 'EUR'
    amount 10_000
    max_waiting_time 25
    date_from Date.new(2020, 8, 20)
    date_to Date.new(2020, 8, 20) + 25.weeks
  end
end
