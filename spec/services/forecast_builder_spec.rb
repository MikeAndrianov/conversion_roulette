require 'rails_helper'

RSpec.describe ForecastBuilder do
  subject(:builder) { described_class.new(forecast) }

  let(:forecast) { build(:forecast) }

  before { allow(ForecastPredictionJob).to receive(:perform_later).with(forecast) }

  describe '#perform' do
    it 'changes forecast status' do
      expect { builder.perform }.to change { forecast.state }.from('data_collecting').to('processing')
    end

    it 'starts prediction job' do
      builder.perform

      expect(ForecastPredictionJob).to have_received(:perform_later).with(forecast)
    end
  end

  describe '#rebuild' do
    let!(:forecast_currency_rate) { create(:forecast_currency_rate, forecast: forecast) }

    before { allow(builder).to receive(:perform) }

    it 'deletes all forecast currency rates and triggers #perform' do
      expect { builder.rebuild }.to change { forecast.forecast_currency_rates.count }.from(1).to(0)
    end
  end
end
