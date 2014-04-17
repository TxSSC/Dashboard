require 'json'
require 'net/http'

SCHEDULER.every '1m', :first_in => 0 do |job|
  http = Net::HTTP.new('sentinel.texasschoolsafetycenter.com')
  response = http.request(Net::HTTP::Get.new("/"))
  servers = JSON.parse(response.body)

  if servers
    servers = servers.map do |k, v|
      {
        :name => k,
        :isGreen => v,
        :isRed => !v
      }
    end

    servers.sort! do |a, b|
      a[:name].downcase <=> b[:name].downcase
    end

    send_event('sentinel', items: servers)
  end
end
