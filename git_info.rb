require "json"
require 'rsolr'

@records = {}
def inital(contributer)
  @records[contributer] = {}
  @records[contributer]['assigned_issues'] = []
  @records[contributer]['opened_issues'] = []
  @records[contributer]['commits'] = []
end


fr_issues = File.open('scarecrow_issues.json')
content = fr_issues.read
issues = JSON.parse(content);
puts issues.length
for issue in issues
  if issue['assignee']
    if !@records.has_key?(issue['assignee']['login'])
      inital(issue['assignee']['login'])
    end
    @records[issue['assignee']['login']]['assigned_issues'] << issue['body']
  end
  if !@records.has_key?(issue['user']['login'])
    inital(issue['user']['login'])
  end
  @records[issue['user']['login']]['opened_issues'] << issue['body']
end


fr_commits = File.open('scarecrow_commits.json')
content = fr_commits.read
commits = JSON.parse(content)
for commit in commits
  if !@records.has_key?(commit['committer']['login'])
    inital(commit['committer']['login'])
  end
  @records[commit['committer']['login']]['commits'] << commit['commit']['message']
end

solr = RSolr.connect :url => 'http://10.20.10.249:8983/solr/ninja'
@records.each do |id, content|
  content.each do |key, value|
    content[key] = value.join(' ')
  end
  content['id'] = id
  puts JSON.generate(content)
  solr.add content
  solr.commit
end

