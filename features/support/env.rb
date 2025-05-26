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
require "nokogiri"
require "httpclient"
require "json_schemer"
require "oj"
require "capybara/cucumber"
require "selenium-webdriver"
require "dotenv/load"

# Load helper classes
require_relative "helpers/utils"
require_relative "helpers/api"
require_relative "helpers/json_schema_helper"
require_relative "logger"
require_relative "constants"
require_relative "run_test"
require_relative "otp_helper"


# Load .env file
Dotenv.load

# Set global Oj config
Oj.default_options = { mode: :compat }

#Json matchers configuration
World(JsonSchemaHelper)

# Include RSpec matchers to be used globally (e.g. in Utils)
include RSpec::Matchers

# Allure configuration
AllureCucumber.configure do |config|
  config.results_directory = "allure-results"
  # config.clean_results_directory = true
  config.logging_level = ENV['DEBUG'].to_s.downcase == 'true' ? Logger::DEBUG : Logger::ERROR
end

# # OtpHelper configuration
# World(OtpHelper)

# # Capybara Configuration
# Capybara.register_driver :selenium_chrome_headless_stealth do |app|
#   options = Selenium::WebDriver::Chrome::Options.new
#   options.add_argument('--headless')
#   options.add_argument('--disable-gpu')
#   options.add_argument('--no-sandbox')
#   options.add_argument('--disable-dev-shm-usage')
#   options.add_argument('--window-size=1400,900')
#   # Trick for avoid detected as bot
#   options.add_argument('--disable-blink-features=AutomationControlled')
#   options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36')
  
#   Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
# end

# Capybara.default_driver = :selenium_chrome_headless_stealth
# Capybara.app_host = ENV['NOTIFICATION_URL']
# Capybara.default_max_wait_time = 15 # default wait time for elements to appear
# Capybara.run_server = false

# # Hook for make sure browser session is closed
# After do
#   Capybara.reset_sessions!
# end

