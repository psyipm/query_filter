module QueryFilter::Utils
  # Usage:
  #
  #   range = Utils::ScopeRange.new(:orders, { orders_from: 1, orders_to: 44 })
  #   range.query('orders_count')
  #
  class ScopeRange
    def initialize(name, options = {})
      @name = name
      @options = options
    end

    def name_from
      @name_from ||= "#{@name}_from".to_sym
    end

    def name_to
      @name_to ||= "#{@name}_to".to_sym
    end

    def value_from
      @options[name_from]
    end

    def value_to
      @options[name_to]
    end

    def valid?
      @options && (value_from.present? || value_to.present?)
    end

    def query(column)
      if value_from.present? && value_to.present?
        ["#{column} BETWEEN ? AND ?", value_from, value_to]
      elsif value_from.present?
        ["#{column} >= ?", value_from]
      elsif value_to.present?
        ["#{column} <= ?", value_to]
      end
    end
  end
end
