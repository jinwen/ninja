require 'rubygems'
require 'rsolr'

# Direct connection
solr = RSolr.connect :url => 'http://10.20.10.249:8983/solr/'
# send a request to /select
response = solr.get 'select', :params => {:q => 'price:1'}

puts response
