class ForecastsController < ApplicationController
  before_action :set_forecast, only: %i[show edit update destroy]
  before_action :build_forecast, only: :create

  def index
    @forecasts = current_user.forecasts
  end

  def show; end

  def new
    @forecast = current_user.forecasts.build
  end

  def edit; end

  def create
    respond_to do |format|
      if @forecast.save
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

  def forecast_params
    params.require(:forecast).permit(:currency, :amount, :target_currency, :max_waiting_time)
  end

  def build_forecast
    @forecast = current_user.forecasts.build(forecast_params)
  end
end
