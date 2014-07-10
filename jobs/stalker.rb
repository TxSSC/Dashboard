require 'net/http'
require 'json'

SCHEDULER.every '30s', :first_in => 0 do |job|
  http = Net::HTTP.new('stalker.txssc.com')
  request = Net::HTTP::Get.new("/api/users")
  request['Authorization'] = settings.STALKER_TOKEN
  response = http.request(request)
  users = JSON.parse(response.body)['users']

  if users.length > 0
    users.select! { |u| u['division'] == 3 } # Filter IT

    users.map! do |user|
      location = user['location'].downcase
      user = { :name => user['name'] }

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
