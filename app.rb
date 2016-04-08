require 'slack-ruby-bot'
require 'json'
require 'net/http'
require 'uri'

# usage:
#   SLACK_API_KEY=<key> bundle exec ruby app.rb

class BleepBloop < SlackRubyBot::Bot
  match /^blee(?<extension>e*)p(?<punctuation>[?!]*)$/i do |client, data, match|
    client.say(text: "bloo#{"o" * match[:extension].length}p#{"!" * match[:punctuation].length}", channel: data.channel)
  end

  match /^bloo(?<extension>o*)p(?<punctuation>[?!]*)$/i do |client, data, match|
    client.say(text: "blee#{"e" * match[:extension].length}p#{"!" * match[:punctuation].length}", channel: data.channel)
  end

  match /~~danny~~/ do |client, data, match|
    client.say(text: "ᕕ( ᐛ )ᕗ what a great guy!", channel: data.channel)
  end

  match /rick and morty/ do |client, data, match|
    client.say(gif: 'rick and morty', channel: data.channel)
  end

  RESPONSES = [
    'As the prophecy foretold.',
    'But at what cost?',
    'So let it be written; so let it be done.',
    'So... It has come to this.',
    'That\'s just what they would have said',
    'Is this why fate brought us together?',
    'And thus, I die.',
    '... just like in my dream...',
    'Be that as it may, still may it be as it may be.',
    'There is no escape from destiny.',
    'Wise words by wise men write wise deeds in wise pen.',
    'In _this_ economy?',
    '... and then out come the wolves',
  ]

  NAMES = /(bleep bloop|bleepy|bloopy)/
  match /^(?<statement>.*), #{NAMES}(?<question>\??)/ do |client, data, match|
    text = if match[:question] == '?'
      RESPONSES.shuffle.pop
    else
      "#{match[:statement]} too, <@#{data.user}>!"
    end
    client.say(text: text, channel: data.channel);
  end

  match /gimme some dank memes/ do |client, data, match|
    client.say(text: "You got it, bud.", channel: data.channel)
    client.say(gif: 'dank memes', channel: data.channel)
  end

  command 'pugbomb' do |client, data, match|
    json = JSON.parse(Net::HTTP.get(URI('http://pugme.herokuapp.com/bomb?count=10')))
    json["pugs"].each do |pug|
        client.say(text: pug, channel: data.channel)
    end
  end

  command 'goatbomb' do |client, data, match|
    10.times do
        client.say(gif: 'goat', channel: data.channel)
    end
  end

  command 'puppybomb' do |client, data, match|
    10.times do
        client.say(gif: 'puppy', channel: data.channel)
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

