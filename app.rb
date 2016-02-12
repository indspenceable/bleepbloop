require 'slack-ruby-bot'
require 'json'
require 'net/http'
require 'uri'

# usage:
#   SLACK_API_KEY=<key> bundle exec ruby app.rb

class BleepBloop < SlackRubyBot::Bot
  match /^bleep$/ do |client, data, match|
    client.say(text: "bloop", channel: data.channel)
  end

  match /^bloop$/ do |client, data, match|
    client.say(text: "bleep", channel: data.channel)
  end

  command 'pugbomb' do |client, data, match|
    json = JSON.parse(Net::HTTP.get(URI('http://pugme.herokuapp.com/bomb?count=10')))
    json["pugs"].each do |pug|
        client.say(text: pug, channel: data.channel)
    end
  end

  IMAGES = {
    'aliensguy' => 'aliensguy.jpg',
    'braceyourself' => 'braceyourself.jpg',
    'condescendingwonka' => 'condescendingwonka.jpg',
    'confessionbear' => 'confessionbear.jpg',
    'conspiracykeanu' => 'conspiracykeanu.jpg',
    'ermahgerd' => 'ermahgerd.jpg',
    'firstdayinternetkid' => 'firstdayinternetkid.jpg',
    'firstworldproblems' => 'firstworldproblems.jpg',
    'freshman' => 'freshman.jpg',
    'futuramafry' => 'futuramafry.jpg',
    'goodguygreg' => 'goodguygreg.jpg',
    'grumpycat' => 'grumpycat.jpg',
    'mostinterestingman' => 'mostinterestingman.jpg',
    'onedoesnotsimply' => 'onedoesnotsimply.jpg',
    'overlyattachedgirlfriend' => 'overlyattachedgirlfriend.jpg',
    'scumbagsteve' => 'scumbagsteve.jpg',
    'sociallyawesomepengiun' => 'sociallyawesomepengiun.jpg',
    'sociallyawkwardpengiun' => 'sociallyawkwardpengiun.jpg',
    'successkid' => 'successkid.jpg',
    'suddenclarityclarence' => 'suddenclarityclarence.jpg',
    'trollface' => 'trollface.jpg',
    'xzibit' => 'xzibit.jpg',
    'yunoguy' => 'yunoguy.jpg',
  }

  match /^memegen (?<image>.*);(?<text0>.*);(?<text1>.*)$/ do |client, data, match|
    image_url = if match[:image] =~ URI::regexp
        match[:image]
    elsif (IMAGES.key?(match[:image]))
        IMAGES[match[:image]]
    end


    if image_url
        text0 = URI.escape(match[:text0])
        text1 = URI.escape(match[:text1])
        client.say(text: "http://memeifier.com/#{text0}/#{text1}/#{image_url}", channel: data.channel)
    else
        client.say(text: "I don't know that image", channel: data.channel)
    end
  end
end

BleepBloop.run

