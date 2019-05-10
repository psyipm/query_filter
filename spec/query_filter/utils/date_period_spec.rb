# frozen_string_literal: true

require 'spec_helper'

RSpec.describe QueryFilter::Utils::DatePeriod do
  let(:period) { described_class.new }

  it 'should init default range' do
    expect(period.default?).to eq true
    expect(period.date_from).to eq Time.zone.today.beginning_of_day
    expect(period.date_to).to eq Time.zone.today.end_of_day
  end

  it 'should respond to range' do
    expect(period.range.is_a?(Range)).to eq true
  end

  it 'should respond to title' do
    expect(period.title).not_to be blank?
  end

  it 'should parse dates from string' do
    params = '06/24/2017 to 06/30/2017'
    period = described_class.parse_from_string(params)

    from = period.date_from
    expect([from.month, from.day, from.year]).to eq [6, 24, 2017]

    to = period.date_to
    expect([to.month, to.day, to.year]).to eq [6, 30, 2017]
  end

  it 'should parse date in format iso8601' do
    from = 2.days.ago.iso8601
    to = 1.day.ago.iso8601
    period = described_class.new(from, to)

    expect(period.date_from_original.iso8601).to eq from
    expect(period.date_to_original.iso8601).to eq to
  end
end
