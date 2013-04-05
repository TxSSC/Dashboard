require 'net/http'
require 'json'

SCHEDULER.every '2m', :first_in => 0 do |job|
  http = Net::HTTP.new('stalker.texasschoolsafetycenter.com')
  response = http.request(Net::HTTP::Get.new("/users"))
  users = JSON.parse(response.body)

  if users
    users.map! do |user|
      { name: user['name'].capitalize,
        status: user['location'].match(/^\s*(?:strahan|strahan\s+house)\s*$/i) != nil
      }
    end

    send_event('stalker', data: users)
  end
end