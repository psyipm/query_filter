require 'spec_helper'

RSpec.describe QueryFilter::Utils::DatePeriod do
  it 'should init default range' do
    period = described_class.new

    expect(period.default?).to eq true
    expect(period.date_from).to eq Time.zone.today.beginning_of_day
    expect(period.date_to).to eq Time.zone.today.end_of_day
  end

  it 'should respond to range' do
    period = described_class.new

    expect(period.range.is_a?(Range)).to eq true
  end

  it 'should parse dates from string' do
    params = '06/24/2017 to 06/30/2017'
    period = described_class.parse_from_string(params)

    from = period.date_from
    expect([from.month, from.day, from.year]).to eq [6, 24, 2017]

    to = period.date_to
    expect([to.month, to.day, to.year]).to eq [6, 30, 2017]
  end
end
