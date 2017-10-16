require 'rails_helper'

describe ForecastsHelper do
  describe '#format_date' do
    it { expect(helper.format_date(Date.new(2017, 10, 10))).to eq('2017 Oct 10') }
  end

  describe '#state_badge' do
    it { expect(helper.state_badge('processing')).to eq('<span class="badge badge-warning">processing</span>') }
    it { expect(helper.state_badge('completed')).to eq('<span class="badge badge-success">completed</span>') }
    it { expect(helper.state_badge('failed')).to eq('<span class="badge badge-danger">failed</span>') }
    it { expect(helper.state_badge('another')).to eq('<span class="badge badge-secondary">another</span>') }
  end
end
