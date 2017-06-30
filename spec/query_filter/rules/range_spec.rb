require 'spec_helper'

RSpec.describe QueryFilter::Rules::Range do
  it 'should init range' do
    range = described_class.new(:orders, orders_from: 1, orders_to: 10)

    scope_range = range.normalize_params(orders_from: 1, orders_to: 10)
    expect(scope_range.is_a?(QueryFilter::Utils::ScopeRange)).to eq true

    expect(scope_range.value_from).to eq 1
    expect(scope_range.value_to).to eq 10
  end
end
