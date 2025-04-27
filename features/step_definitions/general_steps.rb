When(/^user set request timeout to "(.*ms|.*s)"$/) do |timeout|
  value = Utils.resolve_env(self, timeout)
  value = Utils.resolve_variable(self, value)

  if value.end_with?("ms")
    @request_timeout = value.to_i / 1000.0
  elsif value.end_with?("s")
    @request_timeout = value.to_i
  else
    raise "Invalid timeout format: #{value}"
  end
end

Given(/^user define value "([^"]+)" with variable "([^"]+)"$/) do |variable_value, var|
  value = Utils.resolve_env(self, variable_value)
  value = Utils.resolve_variable(self, value)
  instance_variable_set("@#{var}", value)
end

# Example:
# Given user define env variable "MY_ENV_VAR:12345"
# - This will set the environment variable `MY_ENV_VAR` to the value `12345`.
Given(/^user define env variable "([^"]+)"$/) do |var|
  var = Utils.resolve_env(self, var)
  var = Utils.resolve_variable(self, var)
  
  key, value = var.split(":")

  ENV[key] = value
end

Given(/^user collects data from ENV "([^"]+)" as "([^"]+)"$/) do |env, var|
  value = ENV[env]
  instance_variable_set("@#{var}", value)
end

When(/^user collects data from response with json path "([^"]+)" as "([^"]+)"$/) do |json_path, var|
  path = Utils.resolve_env(self, json_path)
  path = Utils.resolve_variable(self, path)
  result = JsonPath.new("$.#{path}").on(@response.body).first
  instance_variable_set("@#{var}", result)
end

Given(/^user wait until "(\d+|\d.\d+)" seconds$/) do |seconds|
  sleep seconds.to_f
end

When(/^extract string "([^"]*)" using regex "([^"]*)" as "([^"]*)"$/) do |string, regex, var|
  string = Utils.resolve_env(self, string)
  string = Utils.resolve_variable(self, string)
  result = string.match(Regexp.new(regex))
  instance_variable_set("@#{var}", result ? result[1] : nil)
end

When(/^user generate random text ?(?:"([^"]+)")? with variable "([^"]+)"$/) do |value, var|
  result = value.nil? || value.empty? ? SecureRandom.hex(4) : value + SecureRandom.hex(4)
  instance_variable_set("@#{var}", result)
end

When(/^format date "([^"]*)" to "([^"]*)" and save as variable "([^"]*)"$/) do |date, date_format, variable_name|
  resolved_date = Utils.resolve_env(self, date)
  resolved_date = Utils.resolve_variable(self, resolved_date)
  formatted_date = DateTime.parse(resolved_date).strftime(date_format)
  instance_variable_set("@#{variable_name}", formatted_date)
end

When(/^user generate random integer between "(\d+)" and "(\d+)" and save as variable "([^"]*)"$/) do |min, max, variable_name|
  instance_variable_set("@#{variable_name}", rand(min.to_i..max.to_i))
end

When(/^user generate random string of "([^"]+)" characters with variable "([^"]+)"$/) do |number_of_character, var|
  instance_variable_set("@#{var}", SecureRandom.alphanumeric(number_of_character.to_i))
end

When(/^user generate uuid with variable "([^"]*)"$/) do |variable_name|
  instance_variable_set("@#{variable_name}", SecureRandom.uuid)
end