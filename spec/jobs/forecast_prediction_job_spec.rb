require 'rails_helper'

RSpec.describe ForecastPredictionJob, type: :job do
  describe '#perform' do
    subject(:run_job) { described_class.new.perform(forecast) }

    let(:forecast) { build(:forecast, state: :processing) }
    let(:predictor_instance) { instance_double('CurrencyRatesPredictor') }

    before do
      allow(CurrencyRate).to receive(:find_or_fetch)
      allow(CurrencyRatesPredictor).to receive(:new).and_return(predictor_instance)
      allow(predictor_instance).to receive(:perform)
    end

    it 'fetches currency rates and runs predictor' do
      run_job

      expect(CurrencyRate).to have_received(:find_or_fetch)
      expect(predictor_instance).to have_received(:perform)
    end

    context 'error was raised' do
      before { allow(predictor_instance).to receive(:perform).and_raise(FixerApi::ResponseError) }

      it 'changed forecast status to failed and raise error' do
        expect { run_job }.to raise_error

        expect(forecast.state).to eq('failed')
      end
    end
  end
end
