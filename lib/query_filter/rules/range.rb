# Define range filter rule
#
module QueryFilter::Rules
  class Range < Scope
    def initialize(keys, options = {})
      @key = Array(keys).first
      @keys = [key_from, key_to]
      @options = options
    end

    def name
      'range'.freeze
    end

    def valid?(values)
      filter = build_range_from_params(values)
      filter.valid?
    end

    def normalize_params(values)
      build_range_from_params(values)
    end

    protected

    def build_range_from_params(params)
      QueryFilter::Utils::ScopeRange.new(key, params)
    end

    def key_from
      @key_from ||= "#{key}_from".to_sym
    end

    def key_to
      @key_to ||= "#{key}_to".to_sym
    end
  end
end
