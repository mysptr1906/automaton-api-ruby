require "dotenv"
require "httparty"
require "json"
require "jsonpath"
require "json-schema"
require "cucumber"
require "rspec"
require "rspec/expectations"
require "json_matchers/rspec"
require "logger"
require "securerandom"
require "date"
require "allure-cucumber"

# Load helper classes
require_relative "helpers/utils"
require_relative "helpers/api"
require_relative "helpers/logger"

# Load .env file
Dotenv.load

# Include RSpec matchers to be used globally (e.g. in Utils)
include RSpec::Matchers

# Allure configuration
AllureCucumber.configure do |config|
  config.results_directory = "allure-results"
  config.clean_results_directory = true
  config.logging_level = ENV["CI_COMMIT_BRANCH"].nil? ? Logger::DEBUG : Logger::ERROR #Kasih kondisi debug kalau run di local aja
end

# CI_COMMIT_BRANCH=branch cucumber --tags @TEST_STEP1
