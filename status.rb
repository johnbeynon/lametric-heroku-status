require 'sinatra'
require 'json'
require 'excon'
require 'redis'

$stdout.sync = true

CACHE_STATUS_FOR = ENV["CACHE_STATUS_FOR"] || 60 # in seconds

configure do
  uri = URI.parse(ENV["REDIS_URL"] || 'redis://localhost:6379')
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

end

get '/' do
  production, development = getStatus

  content_type :json
  {
    frames: [
      {
        index: 0,
        text: "Status",
        icon: "i972"
      },
      {
        index: 1,
        text: "Prod",
        icon: icon(production)
      },
      {
        index: 2,
        text: "Dev",
        icon: icon(development)
      }
    ]
  }.to_json
end

def getStatus
  production = $redis.get('production')
  development = $redis.get('development')

  unless production && development
    response = Excon.get('https://status.heroku.com/api/v3/current-status')
    json = JSON.parse(response.body)
    production = json['status']['Production']
    development = json['status']['Development']
    time = Time.now.getutc
    $redis.setex('production', CACHE_STATUS_FOR, production)
    $redis.setex('development', CACHE_STATUS_FOR, development)
  else
    time = 'cached'
  end
  puts "time=#{time} production=#{production} icon=#{icon(production)} development=#{development} icon=#{icon(development)}"

  return production, development
end

def icon(status)
  case status
  when 'red'
    return 'i1479'
  when 'green'
    return 'i1480'
  when 'yellow'
    return 'i1478'
  end
end
