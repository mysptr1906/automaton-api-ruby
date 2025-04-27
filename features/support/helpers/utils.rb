class Utils
  extend RSpec::Matchers

  class << self
    def resolve_variable(object, target, matcher = /{([a-zA-Z0-9_]+)}/)
      target.gsub(matcher) do |var|
        var.gsub!(/[{}]/, "")
        value = object.instance_variable_get("@#{var}")
        puts "Variable @#{var} is nil or false!" unless value
        value
      end || target
    end

    def resolve_env(_object, target, matcher = /{ENV:([a-zA-Z0-9_]+)}/)
      target.gsub!(matcher) do |env_var|
        match = Regexp.last_match
        value = ENV[match[1]]
        puts "Variable @#{env_var} is nil or false!" unless value
        value
      end || target
    end

    def status_code?(expected, response)
      status_code = response.code.to_i

      error_message = <<~MESSAGE
        \nExpected Status Code Not #{expected}
        Actual Status Code: #{status_code}
        Response Body
        #{JSON.parse(response.to_json)}
      MESSAGE

      expect(status_code).to eq(expected), error_message
    end

    def get_json_value(json, path)
      JsonPath.new(json_path).on(json).first
    end

    def numeric?(str)
      begin
        Float(str)
        true
      rescue ArgumentError, TypeError
        false
      end
    end
  end
end
