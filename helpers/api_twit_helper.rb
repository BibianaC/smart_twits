 module Twitter_Helpers 

  def save_data(filename,item)
    file = File.open(filename, 'w')
    file.puts item
    file.close()
  end

  def get_tweet_from_file (filename)
    array_of_hashes = []
    file = File.open(filename, 'r')
    file.readlines.each do |el|
      array_of_hashes << eval(el.chomp)
    end
    file.close()
    return array_of_hashes
  end

  def delete_files_from_directory(dirname)
    FileUtils.rm Dir.glob("#{dirname}/*")
  end

  def save_tweets_per_trend_utility(method_called, path, extension)
    delete_files_from_directory(path)
    get_and_save_tweets method_called, path, extension
  end

  def get_and_save_tweets method_called, path, extension
    trends.each do |trend|
      tweets = get_tweet_from_file(PATH_TWEETS+trend[:filename]+'_tweets.txt')
      method_result =  method_called.call(tweets)
      save_data(path+trend[:filename] + extension, method_result)
    end
  end

 end
