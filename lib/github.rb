require "json"
require "octokit" # github API

module Ninja
  class Github
    def initialize(repo)
      @repo = String.new(repo)
      srepo = repo.sub!('/', '_')

      @assigned_issues = repo + '_assigned_issues'
      @opened_issues = repo + '_opened_issues'
      @issue_comments = repo + '_issue_comments'
      @commits = repo + '_commits'
      @commit_comments = repo + '_commit_comments'
      @records = {}
      @ACCESS_TOKEN = '5d51d6c008713b6f03999d8f542d1f12e4de1b09'
      @client = Octokit::Client.new :access_token => @ACCESS_TOKEN
      @client.auto_paginate = true
    end

    def inital(contributor)
      @records[contributor] = {}
      @records[contributor]['name'] = 'null'
      @records[contributor][@assigned_issues] = []
      @records[contributor][@opened_issues] = []
      @records[contributor][@commits] = []
      @records[contributor][@commit_comments] = []
      @records[contributor][@issue_comments] = []
    end

    def getContributorName(contributor)
      contributor_info = @client.user contributor
      return contributor_info.name
    end

    def getRepoIssues()
      issues_opened = @client.issues @repo, {:state => 'open'}
      issues_closed = @client.issues @repo, {:state => 'closed'}
      issues = issues_opened.concat(issues_closed)
      issues.each do |issue|
        if issue.assignee
          if !@records.has_key?(issue.assignee.login)
            inital(issue.assignee.login)
          end
          @records[issue.assignee.login][@assigned_issues] << issue.body
        end
        if !@records.has_key?(issue.user.login)
          inital(issue.user.login)
        end
        @records[issue.user.login][@opened_issues] << issue.body
      end
    end


    def getRepoIssueComments()
      comments = @client.issues_comments @repo
      comments.each do |comment|
        if !@records.has_key?(comment.user.login)
          inital(comment.user.login)
        end
        @records[comment.user.login][@issue_comments] << comment.body
      end
    end

    def getRepoCommits()
      commits = @client.commits(@repo)
      commits.each do |commit|
        if commit.author
          if !@records.has_key?(commit.author.login)
            inital(commit.author.login)
          end
          @records[commit.author.login][@commits] << commit.commit.message
        end
      end
    end


    def getRepoCommitComments()
      comments = @client.list_commit_comments @repo
      comments.each do |comment|
        if !@records.has_key?(comment.user.login)
          inital(comment.user.login)
        end
        @records[comment.user.login][@commit_comments] << comment.body
      end
    end

    def getRepoInfo()
      getRepoIssues()
      #getRepoIssueComments()
      #getRepoCommits()
      #getRepoCommitComments()
      @records.each do |id, content|
        [@opened_issues, @assigned_issues, @issue_comments, @commits, @commit_comments].each do |key|
          content[key+'_i'] = content[key].length
          content[key] = content[key].join("\n")
        end
        content['id'] = id
        name = getContributorName(id)
        content['name'] = name
      end
      return @records.values
    end
  end
end

#repo = 'factual/scarecrow'
#github = Ninja::Github.new(repo)
#puts github.getRepoInfo()

