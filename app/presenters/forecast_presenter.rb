class ForecastPresenter
  def initialize(view, forecast, currency_rates)
    @view = view
    @forecast = forecast
    @currency_rates = currency_rates

    @exchanged_amounts = @currency_rates.each_with_object({}) do |currency_rate, result|
      result[currency_rate.date] = currency_rate.exchanged_amount(@forecast)
    end
  end

  def exchange_amounts_line_chart(options = {})
    @view.line_chart(@exchanged_amounts, options.merge(scale_options))
  end

  def exchange_amounts_table
    @view.content_tag(:div) do
      currencies_grouped_by_week.each_with_index do |week_data, week_number|
        @view.concat @view.content_tag(:h3,  "Week #{week_number}")
        @view.concat build_table(week_data)
      end
    end
  end

  private

  def scale_options
    values = @exchanged_amounts.values

    {
      min: values.min - values.min * 0.01,
      max: values.max + values.max * 0.01
    }
  end

  def currencies_grouped_by_week
    @currency_rates.each_slice(7)
  end

  def build_table(week_data)
    @view.content_tag(:table, class: 'table table-sm') do
      @view.concat(table_head(week_data))
      @view.concat(table_body(week_data))
    end
  end

  def table_head(week_data)
    @view.content_tag(:thead, class: 'thead-default') do
      @view.content_tag(:tr) do
        @view.concat @view.content_tag(:th, 'Date')
        @view.concat @view.content_tag(:th, "Rate (#{@forecast.currency}/#{@forecast.target_currency})")
        @view.concat @view.content_tag(:th, 'Sum of Exchanged Amount')
        @view.concat @view.content_tag(:th, 'Profit/Loss')
        @view.concat @view.content_tag(:th, 'Rank')
      end
    end
  end

  def table_body(week_data)
    @view.content_tag(:tbody) do
      @view.safe_join(week_data.map { |currency_rate| date_info(currency_rate) })
    end
  end

  def date_info(currency_rate)
    @view.content_tag(:tr) do
      @view.concat @view.content_tag(:td, @view.format_date(currency_rate.date))
      @view.concat @view.content_tag(:td, currency_rate.rate(@forecast))
      @view.concat @view.content_tag(:td, currency_rate.exchanged_amount(@forecast))
      @view.concat @view.content_tag(:td, '?')
      @view.concat @view.content_tag(:td, '??')
    end
  end
end
