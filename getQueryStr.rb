require 'rubygems'
require 'rsolr'


def getQueryStr(*key_words)

  return '*:*' if key_words.empty?
  
  result_str = "commits:#{key_words[0]} OR assigned_issues:#{key_words[0]} OR opened_issues:#{key_words[0]}"
  key_words.shift
  key_words.each{|word|result_str = result_str + " OR commits:#{word} OR assigned_issues:#{word} OR opened_issues:#{word}"}

  return result_str

end

puts getQueryStr('test', 'mul')
