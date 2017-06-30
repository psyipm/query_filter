require 'spec_helper'

RSpec.describe QueryFilter::Base do
  it 'has base class' do
    expect(QueryFilter::Base.new(:query, :filter)).to_not be_nil
  end
end
