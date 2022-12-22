require "bundler/gem_tasks"
require "rake/testtask"
require "rake/extensiontask"

Rake::ExtensionTask.new("tree_stand") do |ext|
  ext.lib_dir = "lib/tree_stand"
  ext.ext_dir = "ext/tree_stand"
end

task :dev do
  ENV['RB_SYS_CARGO_PROFILE'] = 'dev'
end

Rake::TestTask.new(:test) do |t|
  t.deps << :dev << :compile
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
end

task build: :compile
task default: :test
