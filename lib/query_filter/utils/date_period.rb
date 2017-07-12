# frozen_string_literal: true

module QueryFilter
  module Utils
    class DatePeriod
      attr_reader :date_from, :date_to, :format

      TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

      def initialize(date_from = nil, date_to = nil, format = nil)
        @format = (format.blank? ? QueryFilter.date_period_format : format)
        @date_from_raw = date_from
        @date_to_raw = date_to

        @date_from = normalize_date(date_from).beginning_of_day
        @date_to = normalize_date(date_to).end_of_day
      end

      def range
        @range ||= date_from..date_to
      end

      def title
        @title ||= to_human
      end

      def datefrom
        @datefrom ||= I18n.l(@date_from, format: @format)
      end

      def dateto
        @dateto ||= I18n.l(@date_to, format: @format)
      end

      def to_param
        [datefrom, dateto].join(QueryFilter.date_period_splitter)
      end

      def to_human
        [datefrom, dateto].join(" #{QueryFilter.date_period_splitter} ")
      end

      def default?
        @date_from_raw.blank? && @date_to_raw.blank?
      end

      def as_json(options = nil)
        {
          date_from: datefrom,
          date_to: dateto
        }.merge(options || {})
      end

      def self.parse_from_string(value, format = nil)
        return value if value.is_a?(DatePeriod)

        if value.blank?
          new(nil, nil, format)
        else
          dates = value.to_s.split(QueryFilter.date_period_splitter).map(&:strip)
          new(dates[0], dates[1], format)
        end
      end

      private

      def normalize_date(date)
        return date if date.is_a?(Time) || date.is_a?(DateTime)
        return Time.zone.today if date.blank?

        begin
          time = DateTime.strptime(date, @format)
          Time.zone.parse(time.strftime(TIME_FORMAT))
        rescue ArgumentError => _e
          Time.zone.today
        end
      end
    end
  end
end
