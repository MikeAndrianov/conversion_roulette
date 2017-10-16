module ForecastsHelper
  def format_date(date)
    date.strftime('%Y %b %d')
  end

  def state_badge(status)
    badge_type = case status
                 when 'processing'
                   'warning'
                 when 'completed'
                   'success'
                 when 'failed'
                   'danger'
                 else
                   'secondary'
                 end

    content_tag(:span, status, class: "badge badge-#{badge_type}")
  end
end
