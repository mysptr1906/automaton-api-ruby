Given(/^user without headers$/) do
    @headers = {}
end

Given(/^user set header without auth$/) do |headers_json|
    @headers = {
    "User-Agent" => ENV["USER_AGENT"],
    "Content-Type" => "application/json"
  }
end

Given(/^user set header as:$/) do |headers_json|
    resolve_env = Utils.resolve_env(self, headers_json)
    resolve_variable = Utils.resolve_variable(self, headers_json)
  
    headers = headers_json =~ /ENV:/ ? resolve_env : resolve_variable
  
    parsed_headers = JSON.parse(headers)
  
    @headers = (@headers || {}).transform_keys(&:to_s)
    @headers.merge!(parsed_headers.transform_keys(&:to_s))
  end

When(/^user sends a (GET|POST|PUT|DELETE|PATCH) request to "(.*)"(?: with body:)?$/) do |method, endpoint, *args|
    body = args.shift
    title = args[1] || "API Request"
  
    body = body ? Utils.resolve_env(self, body) : nil
    body = body ? Utils.resolve_variable(self, body) : nil
    body_json = body ? JSON.parse(body) : nil
  
    @method = method.downcase
    @headers ||= {}
    @body = @headers["Content-Type"] == "application/json" ? body_json.to_json : body_json
    @endpoint = Utils.resolve_env(self, endpoint)
    @endpoint = Utils.resolve_variable(self, @endpoint)
  
    set_request_timeout = @request_timeout || [10]
    env_request_timeout = ENV["REQUEST_TIMEOUT"]
    get_request_timeout = env_request_timeout.nil? ? set_request_timeout[0] : env_request_timeout.to_i
  
    begin
      @response = Api.request(@method, @endpoint, @headers, @body, get_request_timeout)
    rescue Net::ReadTimeout, Net::OpenTimeout
      raise "request timeout after #{get_request_timeout}"
    end
  end
    



