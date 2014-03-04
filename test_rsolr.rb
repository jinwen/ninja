require 'rubygems'
require 'rsolr'

solr = RSolr.connect :url => 'http://10.20.10.249:8983/solr'
documents = [{:id=>1, :price=>1.00}, {:id=>2, :price=>10.50}]
#solr.add documents

response = solr.get 'select', :params => {:q => '*:*'}
#response["response"]["docs"].each{|doc| puts doc["id"] }
puts response
