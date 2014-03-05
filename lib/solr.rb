require 'json'
require 'rubygems'
require 'rsolr'

module Ninja
  class Solr

    def initialize(args)
      @url=args[:url]
      @solr=RSolr.connect :url => @url
    end

    def search_keyword(s)
      response = @solr.get 'select', :params => {:q => s}
      puts response
    end

    def search_profile()
      #TODO
    end

    def add_docs(docs)
      @solr.add docs, :add_attributes => {:commitWithin => 10}
      @solr.commit
    end

  end
end
