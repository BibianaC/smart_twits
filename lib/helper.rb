module Helper

    REJECT_WORDS = ['rt', 'it', 'was', 'i','a', 'to', 'the', 'on', 'for', 'am','at', 'of', 'do', 'you', 'be', 'in', 'and', 'he', 'with', 'that', 'what', 'are', 'as', 'an', 'all', 'we', "is", "", "can", "this", "now", "your", "you're", "this"]


  def read_file(file_path)
    file = File.open(file_path, 'r')
    array = []
    file.readlines.each do |el| 
      array << eval(el.chomp)
    end
    file.close()
    array
  end

  def parse_file(file_path, regex)
    text = File.read(file_path)
    text.scan(regex).flatten
  end

  def extract_words(array)
    array.join(" ").split(" ").map{ |w| w.downcase.gsub(/\B[@#]\S+\b|(?:f|ht)tps?:\/[^\s]+|[^a-zA-Z0-9%\s]/, "")}
  end

  def reject_words(array)
    array.reject {|w| REJECT_WORDS.include?(w) }
  end

  def count_freq(array)
    word_freq = Hash.new(0)
    array.each {|word| word_freq[word]+=1}
    word_freq
  end

  def filter_top_results(number, hash)
    hash.sort_by {|k, v| v}.reverse[0..(number-1)]
  end

  def find_top_words(number, array)
    words = extract_words(array)
    useful_words = reject_words(words)
    frequency_hash = count_freq(useful_words)
    filter_top_results(number, frequency_hash)
  end

  def find_args(args)
    text_array = read_file(file_path)
    array = []
    text_array.map{|el| array << args}
  end
end


