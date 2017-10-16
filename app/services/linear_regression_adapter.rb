require 'simple_linear_regression'

class LinearRegressionAdapter < BasePredictionAdapter
  def initialize(rates, dates)
    @linear_model = SimpleLinearRegression.new(rates, dates)
  end

  def predict(unix_date)
    # Formula: Y = linear_model.y_intercept + (linear_model.slope * X)
    (unix_date - @linear_model.y_intercept) / @linear_model.slope
  end
end
