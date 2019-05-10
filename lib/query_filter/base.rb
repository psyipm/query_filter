# frozen_string_literal: true

# Build select query based on params hash
#
module QueryFilter
  class Base
    TRUE_ARRAY = [true, 1, '1', 't', 'T', 'true', 'TRUE'].freeze

    class_attribute :filters

    attr_reader :query, :params

    def initialize(scope, params)
      @query = scope
      @params = (params || {})
    end

    def to_query
      active_filters do |filter, values|
        condition = send(filter.endpoint, *values)
        next if condition.nil?

        @query = condition
      end

      @query
    end

    def self.scope(*args)
      filter(Rules::Scope, *args)
    end

    def self.range(*args)
      filter(Rules::Range, *args)
    end

    def self.date_range(*args)
      filter(Rules::DateRange, *args)
    end

    def self.splitter_range(*args)
      filter(Rules::SplitterRange, *args)
    end

    def self.order_by(*args)
      filter(Rules::OrderBy, *args)
    end

    def self.filter(class_name, *args)
      options = args.extract_options!

      self.filters ||= []
      self.filters << class_name.new(args, options)
    end

    protected

    def active_filters
      self.class.filters.each do |filter|
        yield filter, filter.normalize_params(@params) if filter.can_apply?(self)
      end
    end
  end
end
