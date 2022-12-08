require "bundler/setup"
require "tree_stand"
require "pry-byebug" if ENV["PRY"]
require "minitest/autorun"
require "minitest/focus"
require "minitest/reporters"

Minitest::Reporters.use!

TreeStand.configure do
  config.parser_path = File.expand_path(
    File.join(__dir__, "..", "parsers")
  )
end
