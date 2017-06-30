require 'spec_helper'

RSpec.describe QueryFilter::Rules::DateRange do
  it 'should init range' do
    params = '06/24/2017 to 06/30/2017'
    rule = described_class.new(params)

    period = rule.normalize_params(params)
    expect(period.is_a?(QueryFilter::Utils::DatePeriod)).to eq true
  end
end
