# Parse date range params
#
#  date_range :created_at, keys: [:start_date, :end_date]
#
#  date_range :last_login_date
#
module QueryFilter::Rules
  class DateRange < Scope
    def name
      'date_range'.freeze
    end

    def valid?(values)
      period = build_period_from_params(values)
      !(period.nil? || period.default?)
    end

    def normalize_params(values)
      build_period_from_params(values)
    end

    protected

    def build_period_from_params(params)
      if params[key].present?
        QueryFilter::Utils::DatePeriod.parse_from_string(params[key], @options[:format])
      elsif keys_start_end_dates_exists?(params)
        QueryFilter::Utils::DatePeriod.new(*values_start_end_dates(params), @options[:format])
      end
    end

    def keys_start_end_dates_exists?(params)
      values = values_start_end_dates(params)
      !values.nil? && values.size == 2
    end

    def values_start_end_dates(params)
      return if @options[:keys].nil?
      params.values_at(*@options[:keys])
    end
  end
end
