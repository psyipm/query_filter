# frozen_string_literal: true

require 'bundler/setup'
require 'query_filter'
require 'active_support/time'
require 'active_support/core_ext/class'
require 'query_filter_mocks'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.before(:suite) do
    Time.zone = 'Eastern Time (US & Canada)'
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
