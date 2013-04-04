require 'net/http'
require 'json'

SCHEDULER.every '10m', :first_in => 0 do |job|
  key = settings.weather_key
  code = settings.weather_code
  path = "/api/#{key}/conditions/q/#{code}.json"
  response = Net::HTTP.get_response('api.wunderground.com', path)
  weather = JSON.parse(response.body)['current_observation']

  if weather
    send_event('weather', weather: weather)
  end
end