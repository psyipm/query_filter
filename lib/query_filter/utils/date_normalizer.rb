module QueryFilter
  module Utils
    class DateNormalizer
      TIME_FORMAT = '%Y-%m-%d %H:%M:%S'
      PG_MIN_YEAR = -4713
      PG_MAX_YEAR = 294276

      attr_reader :date, :format

      def initialize(date, format)
        @date = date
        @format = format
        @parsed_value = parse
      end

      def normalize
        valid?(@parsed_value) ? @parsed_value : default_date
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

        time = DateTime.strptime(date, format)
        Time.zone.parse(time.strftime(TIME_FORMAT))
      rescue StandardError => _e
        default_date
      end

      def default_date
        Time.zone.today
      end
    end
  end
end
