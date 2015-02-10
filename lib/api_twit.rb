# require 'rubygems'
require 'twitter'
require 'byebug'
require 'rest-client'
require 'json'
require 'open-uri'

PATH = './credentials.md'

class APITwitter

  attr_reader :client

  def initialize
    hash_with_passes = load_passes
    @client = init_twit(hash_with_passes)
    puts @client
  end

  def load_passes(path = PATH)
    return Hash[*File.read(path).split(/[: \n]+/)]
  end

  def init_twit(hash_with_keys)
    # byebug
    Twitter::REST::Client.new do |config|
      config.consumer_key        = hash_with_keys["Consumer_Key(API_Key)"]
      config.consumer_secret     = hash_with_keys["Consumer_Secret(API_Secret)"]
      config.access_token        = hash_with_keys["Access_Token"]
      config.access_token_secret = hash_with_keys["Access_Token_Secret"]
    end
  end

  def get_trends(id_g = 44418)
    @response = @client.trends(id=id_g)
    @response
  end

  def getlocation
     html = open('https://twitter.com/trends?id=44418').read
  end
  
end