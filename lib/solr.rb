require 'json'
require 'rubygems'
require 'rsolr'
require 'curb'

module Ninja
  class Solr

    def initialize(args)
      @url=args[:url]
      @solr=RSolr.connect :url => @url
    end

    def search_keyword(s)
      response = @solr.get 'select', :params => {:q => s}
      ninjas = response["response"]["docs"].map do |ninja|
        {
          "id" => ninja["id"],
          "name" => ninja["name"]
        }
      end
    end

    def search_profile(s)
      response = @solr.get 'select', :params => {:q => s}
      ninjas = response["response"]["docs"].map do |ninja|
        ninja.keep_if {|key,value| key =~ /_i$/ || key == "name" || key == "id"}
      end
    end

    def add_docs(docs)
      update_docs = []
      new_docs=[]
      docs.each do |doc|
        if exist? doc['id']
          update_docs << doc
        else
          new_docs << doc
        end
      end

      @solr.add new_docs
      
      update_docs.each do |doc|
        update_doc(doc)
      end

      @solr.commit
    end

    def update_doc(doc)
      content = {}
      content['id']=doc['id']
      doc.map do |key,value|
        if key != "id" && key != "name"
          content[key] = {
            "set" => value
          }
        end
      end

     json=JSON.generate([content]);
     json.gsub!("'"," ");
     update_url = @url + "/update"

     #`curl #{update_url} -H 'Content-type:application/json' -d '#{json}'`
     c = Curl::Easy.http_post(update_url, json) do |curl|
       curl.headers['Content-Type'] = 'application/json'
     end
    end

    def commit
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
