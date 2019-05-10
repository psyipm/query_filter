# frozen_string_literal: true

module QueryFilter
  module Rules
    class SplitterRange < Scope
      class RangeParam
        SPLITTER = /[;-]/.freeze

        def initialize(value)
          @value = value
        end

        def valid?
          @value.present? && items.size == 2
        end

        def range
          ::Range.new(*items)
        end

        def items
          @items ||= @value.split(SPLITTER).map(&:strip).map(&:to_i)
        end
      end

      def name
        'splitter_range'
      end

      def valid?(values)
        period = build_period_from_params(values)
        !period.nil?
      end

      def normalize_params(values)
        build_period_from_params(values)
      end

      protected

      def build_period_from_params(values)
        param = RangeParam.new(values[key])
        return unless param.valid?

        param
      end
    end
  end
end
