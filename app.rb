require 'slack-ruby-bot'
require 'json'
require 'net/http'
require 'uri'

class BleepBloop < SlackRubyBot::Bot
  match /^bleep$/ do |client, data, match|
    client.say(text: match.inspect  , channel: data.channel)
  end
  command 'pugbomb' do |client, data, match|
    json = JSON.parse(Net::HTTP.get(URI('http://pugme.herokuapp.com/bomb?count=10')))
    json["pugs"].each do |pug|
        client.say(text: pug, channel: data.channel)
    end
  end
end

BleepBloop.run

