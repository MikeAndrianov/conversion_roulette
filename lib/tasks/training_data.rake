# Project: currency-roulette
# Id: currency-prediction
# Bucket: bucket_for_currency_prediction/training_data_2017-10-14.csv
# Model type: REGRESSION

namespace :training_data do
  desc 'Generates training data for neural networks algorithms and saves to CSV'
  task gen_and_save: :environment do
    puts 'Data fetched successfully'
    puts 'Writing to file...'

    write_to_csv(currencies_data)
  end
end

def currencies_data
  CurrencyRate::SUPPORTED_CURRENCIES.map { |currency| fetch_currency(currency) }
end

def fetch_currency(currency)
  puts "Fetching #{currency}"

  begin
    retries ||= 0

    # FixerApi::Client.get_rates_for_period(Time.zone.today - 5.month, Time.zone.today - 1.day, base: currency)
    CurrencyRate.find_or_fetch(currency, ((Time.zone.today - 5.month)..(Time.zone.today - 1.day)))
  rescue StandardError
    sleep(5 * (retries + 1))
    retry if (retries += 1) < 4
  end
end

def write_to_csv(data)
  # TODO : REMOVE EMPTY LINE FROM FILE! GOOGLE API THROWS ERROR!
  CSV.open("tmp/training_data_#{Time.zone.today}.csv", 'wb') do |csv|
    data.compact.each do |currency|
      currency.each_with_index do |currency_rate, day_number|
        next unless currency_rate

        # format: rate, currency, target currency, day
        # FYI: value, that should be predicted should be at first position.
        # https://cloud.google.com/prediction/docs/developer-guide#regression_values
        currency_rate['rates'].each do |target_currency, rate|
          csv << [rate, currency_rate['base'], target_currency, day_number]
        end
      end
    end
  end
end
