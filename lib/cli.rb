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
  ninja = ninja.profile param
  if ninja
    puts "id:   #{ninja["id"]}"
    puts "name: #{ninja["name"]}"
    ninja.each do |key, value|
      if (key != "id" && key != "name")
        key_comp = key.split('_')
        output_key = "#{key_comp[0..1].join('/')} #{key_comp[2..-2].join(' ')}" 
        puts "#{output_key} : #{value}"
      end
    end
  else
    puts "Sorry, no ninja profile for #{param}"
  end
else
  p.educate
end
