require 'spec_helper'

describe ForecastsHelper do
  describe "#format_date" do
    it { expect(helper.format_date(Date.new(2017, 10, 10))).to eq('2017 Oct 10') }
  end
end
