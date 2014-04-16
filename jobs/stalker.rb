require 'net/http'
require 'json'

SCHEDULER.every '30s', :first_in => 0 do |job|
  http = Net::HTTP.new('stalker.texasschoolsafetycenter.com')
  response = http.request(Net::HTTP::Get.new("/users"))
  users = JSON.parse(response.body)

  if users
    users.map! do |user|
      {
        :name => user['name'].capitalize,
        :location => user['location'].capitalize,
        :back => user['back']
      }
    end

    users.sort! do |a, b|
      a[:name].downcase <=> b[:name].downcase
    end

    send_event('stalker', users: users)
  end
end
