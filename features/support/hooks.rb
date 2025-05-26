After do |scenario|
  # Get scenario name
  scenario_name = scenario.name

  # Details Request
  method = instance_variable_get("@method").to_s.upcase
  url = instance_variable_get("@endpoint").to_s
  request_headers = instance_variable_get("@headers").to_s
  request_body = instance_variable_get("@body").to_s
  response_body = instance_variable_get("@response").to_s
  
  is_error = scenario.failed?
  scenario_error = is_error ? scenario.exception.message.to_s.gsub("\n", " ") : "No Error!"
  log_name = "test"
  
  log_details = [
    scenario_name,
    ("ERROR: #{scenario_error}" if is_error),
    "URL: #{method}  #{url}",
    "REQUEST HEADER: #{request_headers}",
    ("REQUEST BODY: #{request_body}" unless request_body == "null"),
    "RESPONSE BODY: #{response_body}"
  ].compact.join("\n")

  logger = log_to_file(log_name)
  is_error ? logger.error(log_details) : logger.info(log_details)
end
