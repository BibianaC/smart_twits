# require 'rubygems'
require 'twitter'
require 'byebug'
require 'rest-client'
require 'json'
require 'open-uri'
require 'json'
require './helpers/api_twit_helper'
require 'cronedit'

PATH = './credentials.md'
LONDON = 44418
PATH_TRENDS = './data/trends/'
PATH_TWEETS = './data/tweets/tweets/'
PATH_TWEETS_TEXT = './data/tweets/text/'
PATH_TWEETS_FOLLOWERS = './data/tweets/followers/'
PATH_TWEETS_RETWEETED = './data/tweets/retweeted/'
MEDIA_GROUP = ['@BBCBreaking','@BBCNews',
         '@guardian','@guardiannews',
        '@MailOnline','@Independent','@SkyNews']

PATH_TWEETS_MEDIA = './data/tweets/media/'

class APITwitter

  include Twitter_Helpers
  include CronEdit

  attr_reader :client, :trends

  def initialize
    hash_with_passes = load_passes
    @client = init_twit(hash_with_passes)
    @trends = []
  end

  def load_passes(path = PATH)
    return Hash[*File.read(path).split(/[: \n]+/)]
  end

  def init_twit(hash_with_keys)
    Twitter::REST::Client.new do |config|
      config.consumer_key        = hash_with_keys["Consumer_Key(API_Key)"]
      config.consumer_secret     = hash_with_keys["Consumer_Secret(API_Secret)"]
      config.access_token        = hash_with_keys["Access_Token"]
      config.access_token_secret = hash_with_keys["Access_Token_Secret"]
    end
  end

  def refresh_all_twitter_data
    save_trends
    save_tweets_per_trend
    save_tweet_text_per_trend
    save_tweets_most_followers_per_trend
    save_tweets_most_retweeted_per_trend
    save_news_media_on_trends
  end

  def save_trends(id_g = LONDON)
    get_trend_data(client.trends(id=id_g))
    delete_files_from_directory(PATH_TRENDS)
    save_data(PATH_TRENDS+'toptrends.txt', trends)
    trends
  end

  def get_trend_data (response)
    response.attrs[:trends].each do |el|
      trends << {:name => el[:name], :query => el[:query], :filename => el[:name].gsub('#','')}
    end
  end

  def save_tweets_per_trend(query_number = 100)
    delete_files_from_directory(PATH_TWEETS)
    save_tweets_to_file(query_number)
  end

  def save_tweets_to_file(query_number)
    trends.each do |trend|
      tweets = get_tweets(trend[:query],query_number)
      save_data(PATH_TWEETS+trend[:filename]+'_tweets.txt',tweets)
    end
  end

  def get_tweets(hash_tag_g, query_number = 100)
    tweets = @client.search(hash_tag_g).take(query_number)
    get_result(tweets)
  end

  def get_result(tweets)
    result=[]
    tweets.each do |el|
      result << {:name => "@"+el.user.screen_name, :text => el.text,
                  :followers => el.user.followers_count,
                  :user_id => el.user.id, :retweet => el.retweet_count}
    end
    result
  end

  def get_tweets_by_user(user,subject,how_many = 1)
    tweets = client.search("#{subject} from:#{user}").take(how_many)
    tweets.map{|el| el.attrs[:text]} unless tweets == nil
  end

  def save_news_media_on_trends(trends=@trends, media = MEDIA_GROUP)
    delete_files_from_directory(PATH_TWEETS_MEDIA)
    trends.each do |trend|
      tweets = extract_media_tweets(trend, media)
      tweets[:media] = "ALL", tweets[:text] = "No news" if tweets.empty?
      save_data(PATH_TWEETS_MEDIA+trend[:filename]+'_med.txt',tweets)
    end
  end

  def extract_media_tweets(trend, media)
    tweets = {}
    media.each do |medium|
      result = get_tweets_by_user(medium,trend[:name])
      tweets[:media] = medium, tweets[:text] = result[0] if result.count != 0
    end
    tweets
  end

  def save_tweet_text_per_trend
    delete_files_from_directory(PATH_TWEETS_TEXT)
    save_tweet_text_per_trend_file
  end

  def save_tweet_text_per_trend_file
    filesaved = 0
    trends.each do |trend|
      tweets = get_tweet_from_file(PATH_TWEETS + trend[:filename] + '_tweets.txt')
      tweet_text = merge_tweets(tweets)
      save_data(PATH_TWEETS_TEXT + trend[:filename] + '_tweets_text.txt', tweet_text)
      filesaved += 1
    end
    filesaved
  end

  def merge_tweets(array_of_hash)
    array_of_hash.reduce('') {|sum, el| sum += el[:text]}
  end

  def save_tweets_most_followers_per_trend(trends = @trends)
    save_tweets_per_trend_utility(trends,method(:top_followers_tweets),PATH_TWEETS_FOLLOWERS,'_tweets_followers.txt')
  end

  def top_followers_tweets(array_of_hashes, number = 3)
    array_of_hashes.sort { |x, y| x[:followers] <=> y[:followers] }.reverse[0..(number-1)]
  end

  def save_tweets_most_retweeted_per_trend(trends = @trends)
    save_tweets_per_trend_utility(@trends,method(:top_retweeted_tweets),PATH_TWEETS_RETWEETED,'_tweets_retweeted.txt')
  end

  def top_retweeted_tweets(array_of_hashes, number = 3)
    top_retweeted = []
    array_of_hashes.each { |el| top_retweeted << {:text => el[:text], :retweet => el[:retweet]} }
    top_retweeted_deduped = top_retweeted.uniq.sort { |x, y| x[:retweet] <=> y[:retweet] }.reverse[0..(number-1)]
    return top_retweeted_deduped
  end


end
