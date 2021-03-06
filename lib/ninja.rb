require_relative 'parser'
require_relative 'github'
require_relative 'solr'

module Ninja
  class Ninja

    @@solr_info = {:url => "http://10.20.10.249:8983/solr/ninja-prod"}

    def initialize
      @parser = QueryParser.new
      @solr_helper = Solr.new @@solr_info
    end

    def build_solr_index(project)
      puts "Building solr index for project #{project}..."
      @github = Github.new(project)
      docs = @github.get_repo_info()
      @solr_helper.add_docs(docs)
      puts "DONE"
    end

    def search_ninja(keywords)
      puts "Searching ninjas about \"#{keywords}\"..."
      solr_query = @parser.convert_to_solr_query keywords
      @solr_helper.search_keyword solr_query
    end

    def profile(id)
      puts "Getting ninja profile of \"#{id}\"..."
      solr_query = @parser.convert_id_query id
      ninjas = @solr_helper.search_profile solr_query
      ninjas[0]
    end
  end
end
