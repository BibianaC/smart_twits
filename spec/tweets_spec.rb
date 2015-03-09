require 'spec_helper'
require './app/lib/tweets'

describe 'Tweets' do

  let(:tweets){Tweets.new}

  context 'finds trends' do

    it 'can read a tweets file and return a list of trends' do
      expect(tweets.read_file('spec/test_data/test_trends.txt')).to be_an_instance_of(Array)
    end

    it 'can create an array of trendnames and filenames' do
      expect(tweets.find_trends('spec/test_data/test_trends.txt')).to include(["#WhatIsLoveIn4Words", "WhatIsLoveIn4Words"])
    end

  end

  context 'find words' do

    it 'can read a tweets file and return a list of words' do
      expect(tweets.read_file('spec/test_data/test.txt')).to be_an_instance_of(Array)
    end

    it 'can take an array of sentences and symbols and return a list of words' do
      expect(tweets.extract_words(["hello &*", "HOW are ! you"])).to eq(["hello", "", "how", "are", "", "you"])
    end

    it 'can take an array of words and reject unwanted words' do
      expect(tweets.reject_words(["and", "it", "", "was", "stupendous"])).to eq(["stupendous"])
    end

    it 'can count the frequency with which the words appear' do
      expect(tweets.count_freq(["hello", "how", "hello", "you", "how"])).to eq({"hello"=>2, "how"=>2, "you"=>1})
    end

    it 'can return the n most frequently occuring words' do
      expect(tweets.find_words(3, 'spec/test_data/test.txt')).to eq([["special", 2], ["know", 2], ["rose", 2]])
    end

  end

  context 'find retweets' do

    it 'can read a tweets file and return an array of tweets and the number of retweets' do
      expect(tweets.find_retweets('spec/test_data/test.txt')).to include(["RT @CNJohansens: What's better than roses this #ValentinesDay? A Rose Petal Body Polish treatment at Armani Hotel Dubai! http://t.co/eD4wIR…", 2])
    end

  end

  context 'find followers' do

    it 'can read a tweets file and return an array of tweets from users with the most followers' do
      expect(tweets.find_followers('spec/test_data/followers.txt')).to include(["@HaitiNewsNet", "Miliband accuses Fink of U-turn - Ed Miliband accuses Lord Fink of an \"extraordinary U-turn\" after the Tory donor ... http://t.co/2Esxo0R6RU", 63743 ])
    end

  end

  context 'find mentions' do

    it "can read a tweets file and return an array of users who've had most mentions" do
      expect(tweets.find_mentions(5, 'spec/test_data/test.txt')).to include(["@FentimansLtd", 1])
    end
    
  end

  context 'find media' do
    it "can read a media file and return an array of trending tweets from media organisations" do
      expect(tweets.find_media('spec/test_data/media.txt')).to include(["@Independent", "RT @thei100: The unluckiest things that have happened on Friday 13 http://t.co/p4Aj50FH0N #FridayThe13th http://t.co/HU2xu3nyhf"])
    end
  end

end
