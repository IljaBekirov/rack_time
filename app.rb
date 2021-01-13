class App
  def call(env)
    [status, headers, body(env)]
  end

  private

  def status
    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body(env)
    env.map! { |format| send('date_time', format) }
    ["Hello, time is #{env.join('-')}\n"]
  end

  def date_time(format)
    case format
    when 'year' then Time.now.year
    when 'month' then check_zero(Time.now.month)
    when 'day' then check_zero(Time.now.day)
    when 'hour' then check_zero(Time.now.hour)
    when 'minute' then check_zero(Time.now.min)
    when 'second' then check_zero(Time.now.sec)
    end
  end

  def check_zero(num)
    num < 10 ? "0#{num}" : num
  end
end
