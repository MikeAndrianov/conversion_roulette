require 'rails_helper'

RSpec.describe CurrencyRate, type: :model do
  it { is_expected.to validate_presence_of(:base) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_presence_of(:rates) }
  it do
    is_expected.to validate_inclusion_of(:base)
        .in_array(%w[AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD HRK HUF IDR ILS INR USD])
  end
end
