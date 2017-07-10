require 'spec_helper'

RSpec.describe QueryFilter::Base do
  let(:user) { User.new(name: 'test_user', login_count: 10, failed_attempts: 5 ) }
  let(:date_range) { [1.day.ago, 1.day.from_now].map { |d| d.strftime('%m/%d/%Y') }.join(' to ') }

  before(:each) do
    user.save
  end

  def query(params)
    User.filter(params).to_sql
  end

  it 'should build scope filter' do
    params = { name: 'test_user' }
    expect(query(params)).to match(/name[\\\"]+ = 'test_user'/)
  end

  it 'should build date range filter' do
    params = { created_at: date_range }
    expect(query(params)).to match(/created_at[\\\"]+ BETWEEN '[\d\-\s:\.]+' AND '[\d\-\s:\.]+'/)
  end

  it 'should build range filter' do
    params = { login_count_from: 4, login_count_to: 14 }
    expect(query(params)).to match(/login_count BETWEEN [\d]+ AND [\d+]/)
  end

  it 'should build range filter with \'from\' param' do
    params = { login_count_from: 4, login_count_to: '' }
    expect(query(params)).to match(/login_count >= [\d+]/)
  end

  it 'should build range filter with \'to\' param' do
    params = { login_count_from: '', login_count_to: 14 }
    expect(query(params)).to match(/login_count <= [\d+]/)
  end

  it 'should build splitter range filter' do
    params = { failed_attempts: '3;12' }
    expect(query(params)).to match(/failed_attempts[\\\"]+ BETWEEN [\d]+ AND [\d+]/)
  end

  it 'should build order_by query with lowercase sort_mode' do
    params = { sort_column: 'login_count', sort_mode: 'desc' }
    expect(query(params)).to match(/ORDER BY [\w\.]+login_count[\\\"]* DESC/i)
  end

  it 'should build order_by query with uppercase sort_mode' do
    params = { sort_column: 'login_count', sort_mode: 'DESC' }
    expect(query(params)).to match(/ORDER BY [\w\.]+login_count[\\\"]* DESC/i)
  end
end
