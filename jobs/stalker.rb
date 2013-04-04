require 'net/http'
require 'json'

SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new('stalker.texasschoolsafetycenter.com')
  response = http.request(Net::HTTP::Get.new("/users"))
  users = JSON.parse(response.body)

  if users
    users.map! do |user|
      { avatar: user['avatar'], location: user['location'], returning: user['returning'] }
    end

    send_event('stalker', users: users)
  end
end