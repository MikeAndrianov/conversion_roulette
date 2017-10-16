class SimpleLinearRegression
  def initialize(xs, ys)
    @xs = xs
    @ys = ys

    raise 'Unbalanced data. xs need to be same length as ys' if @xs.length != @ys.length
  end

  def y_intercept
    mean(@ys) - (slope * mean(@xs))
  end

  def slope
    x_mean = mean(@xs)
    y_mean = mean(@ys)

    numerator(x_mean, y_mean) / denominator(x_mean)
  end

  private

  def mean(values)
    total = values.reduce(0) { |sum, x| x + sum }
    Float(total) / Float(values.length)
  end

  def numerator(x_mean, y_mean)
    (0...@xs.length).reduce(0) do |sum, i|
      sum + ((@xs[i] - x_mean) * (@ys[i] - y_mean))
    end
  end

  def denominator(x_mean)
    @xs.reduce(0) do |sum, x|
      sum + ((x - x_mean)**2)
    end
  end
end
