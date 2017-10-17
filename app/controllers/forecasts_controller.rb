class ForecastsController < ApplicationController
  before_action :set_forecast, only: %i[show edit update destroy]
  before_action :set_forecast_presenter, only: %i[show edit]
  before_action :build_forecast, only: :create

  def index
    set_page_and_extract_portion_from current_user.forecasts.order(updated_at: :desc)
  end

  def show; end

  def new
    @forecast = current_user.forecasts.build
  end

  def edit; end

  def create
    respond_to do |format|
      if @forecast.save
        ForecastBuilder.new(@forecast).perform
        format.html { redirect_to @forecast, notice: 'Forecast was successfully created.' }
        format.json { render :show, status: :created, location: @forecast }
      else
        format.html { render :new }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @forecast.update(forecast_params)
        ForecastBuilder.new(@forecast).rebuild

        format.html { redirect_to @forecast, notice: 'Forecast was successfully updated.' }
        format.json { render :show, status: :ok, location: @forecast }
      else
        format.html { render :edit }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @forecast.destroy
    respond_to do |format|
      format.html { redirect_to forecasts_url, notice: 'Forecast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_forecast
    @forecast = current_user.forecasts.find(params[:id])
  end

  def set_forecast_presenter
    @forecast = ForecastDecorator.new(@forecast)

    currency_rates = @forecast.currency_rates_from_beginning_of_week
    opts = { currency: @forecast.currency, target_currency: @forecast.target_currency }

    @presenter = ForecastPresenter.new(view_context, currency_rates, opts)
  end

  def forecast_params
    params.require(:forecast).permit(:currency, :amount, :target_currency, :max_waiting_time)
  end

  def build_forecast
    @forecast = current_user.forecasts.build(forecast_params)
  end
end
