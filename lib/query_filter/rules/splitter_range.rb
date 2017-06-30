module QueryFilter::Rules
  class SplitterRange < Scope
    class RangeParam
      SPLITTER = /[;-]/

      def initialize(value)
        @value = value
      end

      def valid?
        @value.present? && items.size == 2
      end

      def range
        Range.new(*items)
      end

      def items
        @items ||= @value.split(SPLITTER).map(&:strip).map(&:to_i)
      end
    end

    def name
      'spliter_range'.freeze
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
