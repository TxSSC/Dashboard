require 'json'
require 'net/https'

SCHEDULER.every '5m', :first_in => 0 do |job|
  user = settings.TRAVIS_USER
  repos = settings.TRAVIS_REPOS
  http = Net::HTTP.new('api.travis-ci.org', 443)
  http.use_ssl = true

  travis = repos.map do |repo|
    response = http.request(Net::HTTP::Get.new("/repos/#{user}/#{repo}"))
    data = JSON.parse(response.body)
    { name: data['slug'],
      description: data['description'],
      build: data['last_build_number'],
      duration: data['last_build_duration'],
      passing: data['last_build_status'] == nil || data['last_build_status'] == 0
    }
  end

  if travis.length
    send_event('travis', repos: travis)
  end
end