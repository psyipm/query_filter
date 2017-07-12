# frozen_string_literal: true

require 'spec_helper'

RSpec.describe QueryFilter::Utils::ScopeRange do
  it 'should not be valid without options' do
    range = described_class.new(:orders)
    expect(range.valid?).to eq false
  end

  it 'should build BETWEEN query with FROM and TO arguments' do
    range = described_class.new(:orders, orders_from: 1, orders_to: 44)

    expect(range.valid?).to eq true
    expect(range.query(:orders_count)).to eq ['orders_count BETWEEN ? AND ?', 1, 44]
  end

  it 'should build >= query with FROM argument' do
    range = described_class.new(:orders, orders_from: 1)

    expect(range.valid?).to eq true
    expect(range.query(:orders_count)).to eq ['orders_count >= ?', 1]
  end

  it 'should build <= query with TO argument' do
    range = described_class.new(:orders, orders_to: 44)

    expect(range.valid?).to eq true
    expect(range.query(:orders_count)).to eq ['orders_count <= ?', 44]
  end
end
