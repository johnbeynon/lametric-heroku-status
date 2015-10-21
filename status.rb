require 'sinatra'
require 'json'

get '/' do
  content_type :json
  {
    frames: [
      {
        index: 0,
        text: "Production Status",
        icon: "i972"
      },
        index: 1,
        text: "Development Status",
        icon: "i972"
    ]
  }.to_json
end
