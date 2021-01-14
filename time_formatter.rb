require 'date'

class TimeFormatter
  TIME_FORMATS = { year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S' }.freeze

  def initialize(query_formats)
    @query_formats = query_formats
  end

  def call
    time_string
    unknown_format
  end

  def unknown_format
    @unknown_format ||= (@query_formats - TIME_FORMATS.keys).map(&:to_s)
  end

  def time_string
    @time_string ||= convert_time(@query_formats)
  end

  def success?
    time_string && unknown_format.empty?
  end

  private

  def convert_time(query_formats)
    time = TIME_FORMATS.keys.map { |form| TIME_FORMATS[form] if query_formats.include?(form) }.compact.join('-')
    Time.now.strftime(time)
  end
end
