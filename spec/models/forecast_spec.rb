require 'rails_helper'

RSpec.describe Forecast, type: :model do
  it { is_expected.to belong_to(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:currency) }
    it { is_expected.to validate_presence_of(:target_currency) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:max_waiting_time) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:max_waiting_time).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:max_waiting_time).is_less_than_or_equal_to(250)}

    it do
      is_expected.to validate_inclusion_of(:currency)
        .in_array(%w[AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR USD])
    end

    it do
      is_expected.to validate_inclusion_of(:target_currency)
        .in_array(%w[AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR USD])
    end

    it 'checks date_from less than date_to' do
      forecast = build(:forecast, date_from: Date.new(2020, 8, 20), date_to: Date.new(2020, 7, 20))

      expect(forecast).to_not be_valid
    end

    it 'checks date_from is after today' do
      forecast = build(:forecast, date_from: Date.new(2020, 8, 20), date_to: Date.new(2020, 8, 19))

      expect(forecast).to_not be_valid
    end

    it 'checks currency differs from target_currency' do
      forecast = build(:forecast, currency: 'USD', target_currency: 'USD')

      expect(forecast).to_not be_valid
    end
  end

  describe 'callbacks' do
    let(:forecast) { build(:forecast, max_waiting_time: 1) }

    it 'sets interval between start and end dates' do
      expect { forecast.save }.to change { forecast.date_from }.to(Date.today + 1.day).and \
        change { forecast.date_to }.to(Date.today + 1.week + 1.day)
    end
  end
end
