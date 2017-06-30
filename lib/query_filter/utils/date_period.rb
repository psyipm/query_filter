module QueryFilter::Utils
  class DatePeriod
    attr_reader :date_from, :date_to, :format

    SPLITTER = 'to'.freeze
    DATE_FORMAT = '%m/%d/%Y'.freeze

    def initialize(date_from = nil, date_to = nil, format = nil)
      @format = format || DATE_FORMAT
      @default = (date_from.blank? && date_to.blank?)
      @date_from = normalize_date(date_from || Time.zone.now).beginning_of_day
      @date_to = normalize_date(date_to || Time.zone.now).end_of_day
    end

    def range
      @range ||= date_from..date_to
    end

    def default?
      @default
    end

    def self.parse_from_string(value, format = DATE_FORMAT)
      return value if value.is_a?(DatePeriod)

      if value.blank?
        new(nil, nil, format)
      else
        dates = value.to_s.split(SPLITTER).map(&:strip)
        new(dates.first, dates.last, format)
      end
    end

    private

    def normalize_date(date)
      return date if date.is_a?(Time) || date.is_a?(DateTime)

      begin
        time = DateTime.strptime(date, @format)
        Time.zone.parse(time.strftime('%Y-%m-%d %H:%M:%S'))
      rescue StandardError => _e
        Time.zone.today
      end
    end
  end
end
