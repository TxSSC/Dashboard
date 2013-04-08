require 'dashing'

configure do
  set :auth_token, (ENV['dashing_auth_token'] || 'PLEASE')
  set :weather_key, ENV['dashing_weather_token']
  set :weather_code, 78666
  set :travis_user, 'TxSSC'
  set :travis_repos, ['Stalker', 'Card-Catalog', 'TrapperKeeper']
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