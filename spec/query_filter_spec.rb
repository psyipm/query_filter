require 'spec_helper'

RSpec.describe QueryFilter do
  it 'has a version number' do
    expect(QueryFilter::VERSION).not_to be nil
  end

  it 'loads base class' do
    expect(QueryFilter::Base.new(:query, :filter)).to_not be_nil
  end

  it 'loads rules' do
    expect(QueryFilter::Rules::Scope.new(:keys)).to_not be_nil
    expect(QueryFilter::Rules::Range.new(:value)).to_not be_nil
    expect(QueryFilter::Rules::DateRange.new(:value)).to_not be_nil
    expect(QueryFilter::Rules::SplitterRange.new(:value)).to_not be_nil
    expect(QueryFilter::Rules::OrderBy.new(:value)).to_not be_nil
  end

  it 'loads utils' do
    expect(QueryFilter::Utils::DatePeriod.new).to_not be_nil
    expect(QueryFilter::Utils::ScopeRange.new(:key, key_from: 1)).to_not be_nil
  end
end
