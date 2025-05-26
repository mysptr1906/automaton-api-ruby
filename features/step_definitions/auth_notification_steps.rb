When(/^user get otp from dashboard notification for phone number "(.*)" and save variable as "(.*)"$/) do |phone_number, var|
  @variables ||= {}
  otp_value = get_otp_from_dashboard(phone_number)
  raise "Failed to get OTP for phone number #{phone_number}." if otp_value.nil? || otp_value.empty?
  instance_variable_set("@#{var}", otp_value)
  puts "OTP '#{otp_value}' was successfully saved into variable '@#{var}'."
end
