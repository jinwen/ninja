require 'rubygems'
require 'rsolr'

module Ninja
  class QueryParser
    
    def convert_to_solr_query(query)
      keywords = query.strip.split(" ")
      return '*:*' if keywords.empty?
      
      result_str = "commits:#{keywords[0]} OR assigned_issues:#{keywords[0]} OR opened_issues:#{keywords[0]}"
      keywords.shift
      keywords.each do |word|
        result_str = result_str + " OR commits:#{word} OR assigned_issues:#{word} OR opened_issues:#{word}"
      end

      return result_str
    end
  end
end

