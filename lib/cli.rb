require 'trollop'
require_relative 'ninja'

p = Trollop::Parser.new do
  banner <<-EOS
Usage:
   ninja [command] [options]

[command] are:
  build [project-name]:    build solr index for a github project
  search [keywords]:       search ninjas according to given keywords
  profile [github-id]:     display the ninja profile

[options] are:
  EOS
  opt :help, "print help message", :default => false
end

opts = Trollop::with_standard_exception_handling p do
  raise Trollop::HelpNeeded if ARGV.empty?
  p.parse ARGV
end

ninja = Ninja::Ninja.new
cmd   = ARGV.shift
param = ARGV.join(' ')
case cmd
when "build"
  ninja.build_solr_index param
when "search"
  ninjas = ninja.search_ninja param
  ninjas.each do |ninja|
    puts "  #{ninja['id']}: #{ninja['name']}"
  end
when "profile"
  ninjas = ninja.profile param
  ninjas.each do |ninja|
    ninja.map {|key, value| puts "#{key} : #{value}"}
  end
else
  p.educate
end
