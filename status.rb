require 'sinatra'
require 'json'
require 'excon'

$stdout.sync = true

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
  response = Excon.get('https://status.heroku.com/api/v3/current-status')
  json = JSON.parse(response.body)
  production = json['status']['Production']
  development = json['status']['Development']
  puts "time=#{Time.now.getutc} production=#{production} icon=#{icon(production)} development=#{development} icon=#{icon(development)}"
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
