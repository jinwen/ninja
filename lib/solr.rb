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
      ninjas = response["response"]["docs"].map do |ninja|
        ninja["name"]
      end
    end

    def search_profile(s)
      response = @solr.get 'select', :params => {:q => s}
      ninjas = response["response"]["docs"].map do |ninja|
        ninja.keep_if {|key,value| key =~ /_i$/ || key == "name"}
      end
    end

    def add_docs(docs)
      @solr.add docs, :add_attributes => {:commitWithin => 10}
      @solr.commit
    end

    def delete_doc(id)
      @solr.delete_by_id id
    end

    def exist?(id)
      response =  @solr.get 'select', :params => {:q => "id:#{id}"}
      (response["response"]['numFound'] == 0) ? false : true
    end

  end
end
