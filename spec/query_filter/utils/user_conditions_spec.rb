require 'spec_helper'

RSpec.describe QueryFilter::Utils::UserConditions do
  let(:params) do
    { test: '1' }
  end
  let(:target) { QueryFilter::Base.new(:query, params) }

  it 'should be empty conditions' do
    conditions = described_class.new(target)
    expect(conditions.present?).to eq false
  end

  context 'present' do
    let(:conditions) { described_class.new(target, if: :test_param_eq_one?) }

    it 'should be' do
      expect(conditions.present?).to eq true
    end

    it 'should call if condition' do
      expect(target).to receive(:test_param_eq_one?).and_return(true)
      expect(conditions.passed?).to eq true
    end
  end
end
