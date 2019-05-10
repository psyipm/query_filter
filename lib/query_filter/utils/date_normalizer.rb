# frozen_string_literal: true

module QueryFilter
  module Utils
    class DateNormalizer
      PG_MIN_YEAR = -4713
      PG_MAX_YEAR = 294_276

      attr_reader :date, :format

      def initialize(date, format = nil)
        @date = date
        @format = format
      end

      def parsed_value
        @parsed_value ||= parse
      end

      def normalize
        valid?(parsed_value) ? parsed_value : default_date
      end

      private

      def date?
        date.is_a?(Time) || date.is_a?(DateTime)
      end

      def valid?(value)
        return false unless Date.valid_date?(value.year, value.month, value.day)

        value.year > PG_MIN_YEAR && value.year < PG_MAX_YEAR
      end

      def parse
        return date if date?
        return default_date if date.blank?

        [@format].concat(QueryFilter.datetime_formats).compact.each do |format|
          value = safe_parse_date(date, format)
          return value if value
        end

        default_date
      end

      def safe_parse_date(string, format)
        DateTime.strptime(string, format)
      rescue ArgumentError => _e
        nil
      end

      def default_date
        Time.zone.today
      end
    end
  end
end
