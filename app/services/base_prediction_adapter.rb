class BasePredictionAdapter
  def initialize(rates, dates)
    @rates = rates
    @dates = dates
  end

  def predict
    raise NotImplementedError, "#predict should be implemented in #{self.class.name}"
  end
end
