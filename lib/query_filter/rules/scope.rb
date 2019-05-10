# frozen_string_literal: true

# Define filter rules
#
module QueryFilter
  module Rules
    class Scope
      VALIDATON_KEYS = [:in, :only, :format, :if, :unless].freeze

      attr_reader :keys

      def initialize(keys, options = {})
        @keys = Array(keys)
        @options = options
      end

      def blank_validation?
        (@options.keys & VALIDATON_KEYS).empty?
      end

      def valid?(params)
        values = normalize_params(params)

        checks = []
        checks << @options[:in].include?(values.first) if @options[:in]
        checks << @options[:only].include?(values.first) if @options[:only]
        checks << !values.map(&:blank?).all? if blank_validation?
        checks << @options[:intersect] & Array.wrap(values) if @options[:intersect]

        !checks.empty? && checks.all?
      end

      def endpoint
        @options[:to] || "#{name}_#{key}"
      end

      def name
        'scope'
      end

      def key
        @key ||= @keys.first
      end

      def normalize_params(params)
        params.values_at(*keys)
      end

      def can_apply?(target)
        conditions = QueryFilter::Utils::UserConditions.new(target, @options)

        if conditions.present?
          conditions.passed?
        else
          valid?(target.params)
        end
      end
    end
  end
end
