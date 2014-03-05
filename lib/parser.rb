require 'rubygems'
require 'rsolr'

module Ninja
  class QueryParser

    def convert_to_solr_query(args_str)

        args = args_str.split(' ')
        return '*:*' if args.empty?

        repos = []
        key_words = []
        conj_key_words = ' OR '
        conj_repo = ' OR '
        conj_field = ' OR '

        args.each do |arg|
          break if arg.index(/^@/) != 0
          args = args.drop(1)
          repos << arg[1..-1]
        end
        repos.delete_if {|repo| repo.empty?}
        repos.each{|repo| repo = repo.prepend('factual_') if repo.index(/^factual_/) == nil}


        if !args.empty? && (args.at(0).casecmp('or') == 0 || args.at(0).casecmp('and') == 0) then
          if args.at(0).casecmp('and') == 0 then
            conj_key_words = ' AND '
          end
          args = args.drop(1)
        end

        key_words = args
        if key_words.empty? then
          key_words << '*'
        else
          key_words.each{|word|word<<'~' if word[-1] != '~'}
        end

        # generate key words string
        str_key_words = key_words.join(conj_key_words)

        return str_key_words if repos.empty?

        field_commits = []
        field_commit_comments = []
        field_opened_issues = []
        field_assigned_issues = []
        field_issue_comments = []

        repos.each do |repo|
          field_commits << repo + '_commits' + ':'
          field_commit_comments << repo + '_commit_comments' + ':'
          field_opened_issues << repo + '_opened_issues' + ':'
          field_assigned_issues << repo + '_assigned_issues' + ':'
          field_issue_comments << repo + '_issue_comments' + ':'
        end

        # commits
        str_commits = "#{field_commits[0]}#{str_key_words}"
        for i in 1..field_commits.length-1 do
          str_commits += "#{conj_repo}#{field_commits[i]}#{str_key_words}"
        end

        # commit_comments
        str_commit_comments = "#{field_commit_comments[0]}#{str_key_words}"
        for i in 1..field_commit_comments.length-1 do
          str_commit_comments += "#{conj_repo}#{field_commit_comments[i]}#{str_key_words}"
        end

        # opened_issues
        str_opened_issues = "#{field_opened_issues[0]}#{str_key_words}"
        for i in 1..field_opened_issues.length-1 do
          str_opened_issues += "#{conj_repo}#{field_opened_issues[i]}#{str_key_words}"
        end

        # assigned_issues
        str_assigned_issues = "#{field_assigned_issues[0]}#{str_key_words}"
        for i in 1..field_assigned_issues.length-1 do
          str_assigned_issues += "#{conj_repo}#{field_assigned_issues[i]}#{str_key_words}"
        end
        
        # issue_comments
        str_issue_comments = "#{field_issue_comments[0]}#{str_key_words}"
        for i in 1..field_issue_comments.length-1 do
          str_issue_comments += "#{conj_repo}#{field_issue_comments[i]}#{str_key_words}"
        end

        return str_commits + conj_field + str_commit_comments + conj_field + str_opened_issues + conj_field + str_assigned_issues + conj_field + str_issue_comments

    end

    def convert_id_query(id)
      return "id:#{id}"
    end

  end
end

