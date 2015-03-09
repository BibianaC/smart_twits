require 'sinatra/base'
require 'json'
require './app/lib/tweets'

class SmartTwit < Sinatra::Base

  set :views, Proc.new { File.join(root, "views") }
  set :public_folder, Proc.new { File.join(root, "public") }

  tweets = Tweets.new

  get '/?' do
    @trends_list = tweets.find_trends('./data/trends/toptrends.txt')
    trend_ref = params[:trend] || @trends_list[0][1]
    @retweets = tweets.find_retweets("./data/tweets/retweeted/#{trend_ref}_tweets_retweeted.txt")
    @followers = tweets.find_followers("./data/tweets/followers/#{trend_ref}_tweets_followers.txt")
    @mentions = tweets.find_mentions(5, "./data/tweets/tweets/#{trend_ref}_tweets.txt")
    @words = tweets.find_words(10, "./data/tweets/tweets/#{trend_ref}_tweets.txt")
    @media = tweets.find_media("./data/tweets/media/#{trend_ref}_med.txt")
    erb :layout
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
