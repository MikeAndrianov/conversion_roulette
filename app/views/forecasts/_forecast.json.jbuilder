json.extract!(
  forecast, :id, :currency, :amount, :target_currency, :max_waiting_time,
  :date_from, :date_to, :created_at, :updated_at
)
json.url forecast_url(forecast, format: :json)
