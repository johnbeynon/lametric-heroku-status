require 'sinatra'
require 'json'
require 'excon'

get '/' do
  response = Excon.get('https://status.heroku.com/api/v3/current-status')
  json = JSON.parse(response.body)
  production = json['status']['Production']
  development = json['status']['Development']
  content_type :json
  {
    frames: [
      {
        index: 0,
        text: "Production: #{production}",
        icon: "i972"
      },
        index: 1,
        text: "Development: #{development}",
        icon: "i972"
    ]
  }.to_json
end
