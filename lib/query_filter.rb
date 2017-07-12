# frozen_string_literal: true

require 'query_filter/version'
require 'active_support/time'
require 'active_support/core_ext/class'
require 'active_support/core_ext/object/try'

module QueryFilter
  autoload :Base, 'query_filter/base'

  module Rules
    autoload :Scope, 'query_filter/rules/scope'
    autoload :Range, 'query_filter/rules/range'
    autoload :DateRange, 'query_filter/rules/date_range'
    autoload :SplitterRange, 'query_filter/rules/splitter_range'
    autoload :OrderBy, 'query_filter/rules/order_by'
  end

  module Utils
    autoload :DatePeriod, 'query_filter/utils/date_period'
    autoload :ScopeRange, 'query_filter/utils/scope_range'
    autoload :UserConditions, 'query_filter/utils/user_conditions'
  end

  # Configurable date period format
  mattr_accessor :date_period_format
  self.date_period_format = '%m/%d/%Y'

  # Splitter to parse date period values
  mattr_accessor :date_period_splitter
  self.date_period_splitter = 'to'

  # Default way to setup QueryFilter
  # @example
  #   QueryFilter.setup do |config|
  #     config.date_period_format = '%d-%m-%Y'
  #     config.date_period_splitter = 'until'
  #   end
  #
  def self.setup
    yield self
  end
end
