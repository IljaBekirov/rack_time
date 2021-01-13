require_relative 'middleware/date_time_format'
require_relative 'app'

use DateTimeFormat
run App.new
