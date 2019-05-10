# frozen_string_literal: true

# Define order by filter rule
#
module QueryFilter
  module Rules
    class OrderBy < Scope
      DIRECTIONS = %w[asc desc].freeze

      def name
        'order_by'
      end

      def valid?(params)
        params[key].present? && DIRECTIONS.include?(params[direction_key].try(:downcase))
      end

      def direction_key
        @direction_key ||= (@options[:via] || 'sort_direction').to_sym
      end

      def normalize_params(values)
        [values[key], values[direction_key]]
      end
    end
  end
end
