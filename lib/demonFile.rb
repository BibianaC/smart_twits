require_relative 'api_twit'


twitter = APITwitter.new
twitter.refresh_all_twitter_data
