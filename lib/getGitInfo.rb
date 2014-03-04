require "json"
require "octokit" # github API
require 'rsolr' # solr API

ACCESS_TOKEN = '5d51d6c008713b6f03999d8f542d1f12e4de1b09'

@client = Octokit::Client.new :access_token => ACCESS_TOKEN
Octokit.auto_paginate = true

@records = {}
def inital(contributor)
  @records[contributor] = {}
  @records[contributor]['assigned_issues'] = []
  @records[contributor]['opened_issues'] = []
  @records[contributor]['commits'] = []
  @records[contributor]['commit_comments'] = []
  @records[contributor]['issue_comments'] = []
end

def getRepoContributors(repo)
  contributors = @client.contributors_stats repo
  contributors.each do |contributor|
    puts contributor.author.login
  end
end

def getRepoIssues(repo)
  issues = @client.issues repo
  issues.each do |issue|
    if issue.assignee
      if !@records.has_key?(issue.assignee.login)
        inital(issue.assignee.login)
      end
      @records[issue.assignee.login]['assigned_issues'] << issue.body
    end
    if !@records.has_key?(issue.user.login)
      inital(issue.user.login)
    end
    @records[issue.user.login]['opened_issues'] << issue.body
  end
end


def getRepoIssueComments(repo)
  comments = @client.issues_comments repo
  comments.each do |comment|
    if !@records.has_key?(comment.user.login)
      inital(comment.user.login)
    end
    @records[comment.user.login]['issue_comments'] << comment.body
  end
end

def getRepoCommits(repo)
  commits = @client.commits(repo)
  commits.each do |commit|
    if !@records.has_key?(commit.user.login)
      inital(commit.user.login)
    end
    @records[commit.user.login]['commits'] << commit.commit.message
  end
end


def getRepoCommitComments(repo)
  comments = @client.commit_comments repo
  comments.each do |comment|
    if !@records.has_key?(comment.user.login)
      inital(comment.user.login)
    end
    @records[comment.user.login]['commit_comments'] << comment.body
  end
end

repo = 'factual/scarecrow'
getRepoIssues(repo)
getRepoCommits(repo)
getRepoIssueComments(repo)
getRepoCommitComments(repo)


# store into solr
solr = RSolr.connect :url => 'http://10.20.10.249:8983/solr/ninja'
@records.each do |id, content|
  content.each do |key, value|
    content[key] = value.join("\n")
  end
  content['id'] = id
  solr.add content
  solr.commit
end

