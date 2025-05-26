Then(/^the response status should be "(\d+)"$/) do |code|
    Utils.status_code?(code, @response)
end

Then(/^the response body with json path "(.*)" equal to "(.*)"$/) do |json_path, value|
  # Resolve env & variable value json path
  json_path = Utils.resolve_env(self, json_path)
  json_path = Utils.resolve_variable(self, json_path)

  # Resolve env & variable value data
  value = Utils.resolve_env(self, value)
  value = Utils.resolve_variable(self, value)

  # Get value by json path
  results = JsonPath.new(json_path).on(@response.body).first

  # Normalize both values for comparison
  utf_eight = "UTF-8"
  actual_value = results.to_s.encode(utf_eight)
  expected_value = value.to_s.encode(utf_eight)

  # Handle numeric values
  if Utils.numeric?(actual_value) && Utils.numeric?(expected_value)
    # Convert to BigDecimal for precise numeric comparison
    actual_decimal = BigDecimal(actual_value)
    expected_decimal = BigDecimal(expected_value)

    expect(actual_decimal).to eq(expected_decimal), <<~ERROR
      \nexpected: #{expected_value}
      got: #{actual_value}
    ERROR
  else
    # For non-numeric values, compare strings directly
    expect(actual_value).to eq(expected_value)
  end
end

Then(/^the response body with json path "(.*)" equal to one of "(.*)" with delimiter "(.*)"$/) do |json_path, value_string, delimiter|
  # Resolve values
  json_path = Utils.resolve_env(self, json_path)
  json_path = Utils.resolve_variable(self, json_path)
  
  value_string = Utils.resolve_env(self, value_string)
  value_string = Utils.resolve_variable(self, value_string)
  
  delimiter = Utils.resolve_env(self, delimiter)
  delimiter = Utils.resolve_variable(self, delimiter)
  
  # Ambil expected values berdasarkan delimiter
  expected_values = value_string.split(delimiter).map(&:strip)
  
  # Ambil hasil dari JSON path
  actual_value = JsonPath.new(json_path).on(@response.body).first.to_s.encode("UTF-8")
  
  # Assertion
  expect(expected_values).to include(actual_value), <<~ERROR
    \nExpected one of: #{expected_values.join(', ')}
    Got: #{actual_value}
  ERROR
end

Then(/^the response body should be match with json schema "(.*)"$/) do |schema|
  schemer = load_schemer(schema)
  json_data = Oj.load(@response.body)

  errors = schemer.validate(json_data).to_a
  unless errors.empty?
    formatted_errors = errors.map do |error|
      "Value at `#{error['data_pointer']}` is invalid because: #{error['error']}"
    end.join("\n")
    raise <<~MESSAGE
      JSON Schema Validation Error in "#{schema}":
      #{formatted_errors}
    MESSAGE
  end
end

