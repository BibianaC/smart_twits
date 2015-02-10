require_relative 'helper'

class WordFrequency

  include Helper

  REJECT_WORDS = ['I','a', 'to', 'the', 'on', 'for', 'am','at', 'of', 'do', 'you', 'be', 'in', 'and', 'he', 'with', 'that', 'what', 'are', 'as', 'an', 'all', 'we']
  
  def find_top_results(number, file_path)
    text = read_file(file_path)
    array = make_array(text)
    frequnecy_hash = count_freq(array)
    filter_top_results(number, frequnecy_hash)
  end

  def read_file(file_path)
    File.open(file_path, 'r'){ |f| f.read.gsub(/\B[@#]\S+\b|(?:f|ht)tps?:\/[^\s]+|[^a-zA-Z0-9%\s]/, "")}
  end

  def make_array(text)
    text.split(" ").reject {|w| REJECT_WORDS.include?(w) }
  end

end