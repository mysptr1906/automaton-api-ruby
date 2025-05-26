require_relative "features/support/helpers/utils"
require_relative "features/support/constants"
require_relative "features/support/run_test"

require "dotenv"
require "httparty"
require "jsonpath"
require "cucumber"
require "allure-cucumber"
require 'rspec/expectations'


desc "Generate list of cucumber steps definition"
task :list_cucumber_steps do
  # Define the path to your Cucumber step definition folder
  steps_definition_folder = "features/step_definitions/"

  # Initialize a hash to store the step definitions grouped by directory
  step_definitions = Hash.new { |h, k| h[k] = [] }

  # Read each step definition file and extract step names and definitions
  Dir.glob(File.join(steps_definition_folder, "**", "*.rb")).each do |file|
    directory = File.dirname(file).split("/").last
    content = File.read(file)
    content.scan(/^\s*(Given|When|Then|And|But)\s*\((.*)\)/) do |step_match|
      step_name, step_definition = step_match
      step_definitions[directory] << "#{step_name} #{step_definition}"
    end
  end

  # Print the step definitions for each directory
  puts "Cucumber Step Definitions:"
  step_definitions.each do |directory, definitions|
    puts "#{directory.upcase}:"
    definitions.each do |definition|
      puts "  #{definition}"
    end
    puts
  end
end

desc "Run test"
task :run_test do
  RunTest.run_test(ENV['TEST_SETS'])
end
