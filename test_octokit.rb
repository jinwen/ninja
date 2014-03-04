require "octokit"

Octokit.configure do |c|
  c.login = 'ruichao'
  c.password = 'tju5trrm'
end

user =  Octokit.user

puts user.name
puts user.fields
