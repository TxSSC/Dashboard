require 'json'
require 'net/http'

SCHEDULER.every '1m', :first_in => 0 do |job|
  http = Net::HTTP.new('sentinel.texasschoolsafetycenter.com')
  response = http.request(Net::HTTP::Get.new("/users"))
  servers = JSON.parse(response.body)

  if servers
    send_event('sentinel', items: servers)
  end
end