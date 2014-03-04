require 'trollop'

p = Trollop::Parser.new do
  banner <<-EOS
Usage:                                                                           
   ninja [command] [options]
[command] are:
  build     build solr index for a project
  search    search a ninja
  profile   display the ninja profile
[options] are:
  EOS
  opt :help, "print help message", :default => false
end

opts = Trollop::with_standard_exception_handling p do
  raise Trollop::HelpNeeded if ARGV.empty?
  p.parse ARGV
end

cmd   = ARGV.shift
param = ARGV.shift
case cmd
when "build"
  puts "Building solr index for project #{param}"
when "search"
  puts "Searching people about \"#{param}\""
when "profile"
  puts "Getting the profile of \"#{param}\""
else
  p.educate
end
