require 'net/http'
require 'json'

SCHEDULER.every '5m', :first_in => 0 do |job|
  key = settings.WEATHER_KEY
  code = settings.WEATHER_CODE
  path = "/api/#{key}/conditions/q/#{code}.json"
  response = Net::HTTP.get_response('api.wunderground.com', path)
  weather = JSON.parse(response.body)['current_observation']

  if weather
    send_event('weather', weather: weather)
  end
end
