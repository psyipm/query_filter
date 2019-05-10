# frozen_string_literal: true

module QueryFilter
  module Utils
    class DatePeriod
      attr_reader :date_from_raw, :date_to_raw

      def initialize(date_from = nil, date_to = nil, format = nil)
        @date_from_raw = date_from
        @date_to_raw = date_to
        @format = format
      end

      def range
        @range ||= date_from..date_to
      end

      def range_original
        @range_original ||= date_from_original..date_to_original
      end

      def date_from
        @date_from ||= date_from_original.beginning_of_day
      end

      def date_to
        @date_to ||= date_to_original.end_of_day
      end

      def date_from_original
        @date_from_original ||= normalize_date(@date_from_raw)
      end

      def date_to_original
        @date_to_original ||= normalize_date(@date_to_raw)
      end

      def title
        @title ||= to_human
      end

      def datefrom
        @datefrom ||= I18n.l(date_from, format: date_display_format)
      end

      def dateto
        @dateto ||= I18n.l(date_to, format: date_display_format)
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
          new
        else
          dates = value.to_s.split(QueryFilter.date_period_splitter).map(&:strip)
          new(dates[0], dates[1], format || QueryFilter.date_period_format)
        end
      end

      private

      def date_display_format
        @format || QueryFilter.date_display_format
      end

      def normalize_date(date)
        QueryFilter::Utils::DateNormalizer.new(date, @format).normalize
      end
    end
  end
end
