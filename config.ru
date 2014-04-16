require 'dashing'

configure do
  set :AUTH_TOKEN, (ENV['DASHING_AUTH_TOKEN'] || 'PLEASE')
  set :WEATHER_KEY, ENV['DASHING_WEATHER_TOKEN']
  set :WEATHER_CODE, 78666
  set :TRAVIS_USER, 'TxSSC'
  set :TRAVIS_REPOS, ['grunt-carpenter', 'Locker',
    'Sentinel', 'Stalker', 'Ticket-System']

  # Default dashboard dashing setting
  set :default_dashboard, 'main'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
