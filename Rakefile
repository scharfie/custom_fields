require "bundler/gem_tasks"
require 'rake/testtask'

# https://docs.ruby-lang.org/en/2.1.0/Rake/TestTask.html
Rake::TestTask.new do |t|
  t.libs = ["test"]
  t.pattern = "test/**/test_*.rb"
  t.ruby_opts = ['-w']
end

task :default => :test
