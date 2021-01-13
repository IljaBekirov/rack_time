class DateTimeFormat
  FORMAT_DATETIME = %w[year month day hour minute second].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    return not_found unless check_request?(request.env)

    unknown_formats = request.params['format'].split(',') - FORMAT_DATETIME
    unknown_formats.any? ? bad_request(unknown_formats) : @app.call(streamline(request.params['format'].split(',')))
  end

  private

  def streamline(format)
    FORMAT_DATETIME.map { |form| form if format.include?(form) }.compact
  end

  def not_found
    [404, {}, ["Page not found\n"]]
  end

  def bad_request(formats)
    [400, {}, ["Unknown time format #{formats}\n"]]
  end

  def check_request?(request)
    request['REQUEST_METHOD'] == 'GET' && request['REQUEST_PATH'] == '/time'
  end
end
