require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET #index' do
    before { allow_any_instance_of(Forecast).to receive(:currency_rates_from_beginning_of_week).and_return([]) }

    let!(:forecast) { create(:forecast, user: user) }

    it 'returns a success response' do
      get :index

      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let!(:forecast) { create(:forecast, user: user) }

    before { allow_any_instance_of(Forecast).to receive(:currency_rates_from_beginning_of_week).and_return([]) }

    it 'returns a success response' do
      get :show, params: { id: forecast.to_param }

      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new

      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    let!(:forecast) { create(:forecast, user: user) }

    before { allow_any_instance_of(Forecast).to receive(:currency_rates_from_beginning_of_week).and_return([]) }

    it 'returns a success response' do
      get :edit, params: { id: forecast.to_param }

      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Forecast' do
        expect do
          post :create, params: { forecast: attributes_for(:forecast) }
        end.to change(Forecast, :count).by(1)
      end

      it 'creates forecast for current user' do
        another_user = create(:user)

        post :create, params: { forecast: attributes_for(:forecast, user_id: another_user) }

        expect(Forecast.last.user_id).to eq(user.id)
      end

      it 'redirects to the created forecast' do
        post :create, params: { forecast: attributes_for(:forecast) }

        expect(response).to redirect_to(Forecast.last)
      end
    end

    context 'with invalid params' do
      it 'renders new' do
        post :create, params: { forecast: { currency: 'USD' } }

        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    let!(:forecast) { create(:forecast, user: user) }

    context 'with valid params' do
      it 'updates the requested forecast' do
        put :update, params: { id: forecast.to_param, forecast: { amount: 1000 } }

        forecast.reload

        expect(forecast.amount).to eq(1000)
      end

      it 'redirects to the forecast' do
        put :update, params: { id: forecast.to_param, forecast: { amount: 1000 } }

        expect(response).to redirect_to(forecast)
      end
    end

    context 'with invalid params' do
      it 'renders edit' do
        put :update, params: { id: forecast.to_param, forecast: { amount: 0 } }

        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:forecast) { create(:forecast, user: user) }

    it 'destroys the requested forecast' do
      expect do
        delete :destroy, params: { id: forecast.to_param }
      end.to change(Forecast, :count).by(-1)
    end

    it 'refused destorying other forecast which belongs to other user' do
      another_user = create(:user)
      other_forecast = create(:forecast, user: another_user)

      expect do
        delete :destroy, params: { id: other_forecast.to_param }
      end.to raise_error(ActiveRecord::RecordNotFound)

      expect(another_user.forecasts).to include(other_forecast)
    end

    it 'redirects to the forecasts list' do
      delete :destroy, params: { id: forecast.to_param }

      expect(response).to redirect_to(forecasts_path)
    end
  end
end
