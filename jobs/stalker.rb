require 'net/http'
require 'json'

SCHEDULER.every '30s', :first_in => 0 do |job|
  http = Net::HTTP.new('stalker.texasschoolsafetycenter.com')
  response = http.request(Net::HTTP::Get.new("/users"))
  users = JSON.parse(response.body)

  if users
    users.map! do |user|
      location = user['location'].downcase
      user = { :name => user['name'].capitalize }

      if location == 'in'
        user[:isGreen] = true
      elsif location == 'back'
        user[:isYellow] = true
      elsif location != 'out'
        user[:isBlue] = true
      end

      user
    end

    users.sort! do |a, b|
      a[:name].downcase <=> b[:name].downcase
    end

    send_event('stalker', items: users)
  end
end
