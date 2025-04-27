Then(/^the response status should be "(\d+)"$/) do |code|
    Utils.status_code?(code, @response)
end

Then(/^the response body should be match with json schema "(.*)"$/) do |schema|
    begin
        expect(@response.body).to match_json_schema(schema)
    rescue JSON::Schema::ValidationError => e
        raise "JSON Schema Validation Error: #{e.message}"
    end
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

