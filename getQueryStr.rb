require 'rubygems'
require 'rsolr'


def getQueryStr(*key_words)

  return '*:*' if key_words.empty?
  
  conj_colon = ':'
  conj_or = ' OR '
  conj_and = ' AND '
  
  field_expert_id = 'id'
  key_expert_id = field_expert_id + conj_colon
  
  field_expert_name = 'name'
  key_expert_name = field_expert_name + conj_colon
  
  field_commit = 'commits'
  key_commit = field_commit + conj_colon
  
  field_assigned_issue = 'assigned_issues'
  key_assigned_issue = field_assigned_issue + conj_colon
  
  field_opened_issue = 'opened_issues'
  key_opened_issue = field_opened_issue + conj_colon
  
  result_str = key_commit + key_words.at(0) + conj_or + key_assigned_issue + key_words.at(0) + conj_or + key_opened_issue + key_words.at(0)
  key_words.shift
  key_words.each{|word|result_str = result_str + conj_or + key_commit + word + conj_or + key_assigned_issue + word + conj_or + key_opened_issue + word}

  return result_str
end

puts getQueryStr('test', 'mul')
