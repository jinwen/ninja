#!/usr/bin/ruby
require_relative 'ninja'

repo = "scarecrow_rules"

prod_docs = [{
  "id" => "dongshu-factual",
# "name" => "dongshu-factual",
  "commits_#{repo}" =>"123 123",
  "opened_issues_#{repo}" => "123 123",
  "assigned_issues_#{repo}" => "123 123",
  "issue_comments_#{repo}" => "123 123",
  "commit_comments_#{repo}" => "123 123",
  "#{repo}_commit_i" => 12,
  "#{repo}_opened_issues_i" => 12,
  "#{repo}_assigned_issues_i" => 12,
  "#{repo}_issue_comments_i" => 12,
  "#{repo}_commit_comments_i" => 12
}]


docs = [{
  "id" => "dongshu-factual",
  "789_commits" => "123 i'123",
  "789_opened_issues" => "haha'haha"
}]
solr = Ninja::Solr.new( {:url => "http://10.20.10.249:8983/solr/ninja-prod/"} )
solr.add_docs(docs)
#solr.search_keyword("id:dongshu-factual")
