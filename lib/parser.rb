require 'rubygems'
require 'rsolr'

module Ninja
  class QueryParser
    
    def convert_to_solr_query(*keywords)
      return '*:*' if key_words.empty?
      
      result_str = "commits:#{key_words[0]} OR assigned_issues:#{key_words[0]} OR opened_issues:#{key_words[0]}"
      key_words.shift
      key_words.each do |word|
        result_str = result_str + " OR commits:#{word} OR assigned_issues:#{word} OR opened_issues:#{word}"
      end

      return result_str
    end
  end
end

