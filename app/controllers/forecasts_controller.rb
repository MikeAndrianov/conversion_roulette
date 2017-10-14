class ForecastsController < ApplicationController
  before_action :set_forecast, only: %i[show edit update destroy]
  before_action :build_forecast, only: :create

  def index
    set_page_and_extract_portion_from current_user.forecasts.order(updated_at: :desc)
  end

  def show
    # TODO: fix json response or remove
    @currency_rates = CurrencyRate.where(
      base: @forecast.currency,
      date: dates_range
    ).order(:date)

    @presenter = ForecastPresenter.new(view_context, @forecast, @currency_rates)
  end

  def new
    @forecast = current_user.forecasts.build
  end

  def edit; end

  def create
    respond_to do |format|
      if ForecastBuilder.new(@forecast).perform
        format.html { redirect_to @forecast, notice: 'Forecast was successfully created.' }
        format.json { render :show, status: :created, location: @forecast }
      else
        format.html { render :new }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # ForecastBuilder
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

  def dates_range
    # FOR NOW PREVIEW ONLY CACHED DATA
    # @forecast.date_from.beginning_of_week..@forecast.date_to

    # TODO: REMOVE NEXT TWO LINES
    forecast_days_count = (@forecast.date_from...@forecast.date_to).count
    (@forecast.date_from - forecast_days_count.days)..@forecast.date_from
  end
end
