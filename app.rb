require 'rack'
require_relative 'time_formatter'

class App
  def call(env)
    request = Rack::Request.new(env)
    parse_request(request)
  end

  private

  def parse_request(request)
    check_request?(request) ? check_response(request) : response(status: 404, body: "Page not found\n")
  end

  def check_response(request)
    query_formats = request.params['format'].to_s.split(',').map(&:to_sym)
    time_formatter = TimeFormatter.new(query_formats)
    time_formatter.call

    if time_formatter.success?
      response(status: 200, body: "Hello, time is #{time_formatter.time_string}\n")
    else
      response(status: 400, body: "Unknown time format #{time_formatter.unknown_format}\n")
    end
  end

  def response(options = {})
    Rack::Response.new(options[:body], options[:status], headers).finish
  end

  def check_request?(request)
    request.get? && request.path_info == '/time'
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
