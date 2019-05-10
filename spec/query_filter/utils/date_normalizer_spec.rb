# frozen_string_literal: true

require 'spec_helper'

RSpec.describe QueryFilter::Utils::DateNormalizer do
  let(:format) { '%Y-%m-%d' }
  let(:min_date) { DateTime.strptime('-4714-01-01', format) }
  let(:max_date) { DateTime.strptime('294277-01-01', format) }

  def normalize(date)
    described_class.new(date, format).normalize
  end

  it 'should filter dates lower than postgres min date' do
    expect(normalize(min_date)).to eq Time.zone.today
  end

  it 'should filter dates higher than postgres max date' do
    expect(normalize(max_date)).to eq Time.zone.today
  end

  it 'should filter invalid dates' do
    expect(normalize('23987923592358792375-02-29')).to eq Time.zone.today
    expect(normalize('sjgbu32-123-313')).to eq Time.zone.today
    expect(normalize('2017-02-31')).to eq Time.zone.today
    expect(normalize('2017-02-29')).to eq Time.zone.today
  end

  it 'should parse valid dates' do
    date = 1000.years.from_now
    expect(normalize(date.strftime(format)).to_date).to eq date.to_date

    date1 = 1999.years.ago
    expect(normalize(date1.strftime(format)).to_date).to eq date1.to_date
  end
end
