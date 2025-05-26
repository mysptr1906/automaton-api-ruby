require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'nokogiri'

def initialize_capybara
  start = Time.now
  # Configure Capybara to use Selenium with Chrome
    Capybara.register_driver :selenium_chrome_realistic do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless') # Uncomment for headless mode
    options.add_argument('--disable-blink-features=AutomationControlled')
    options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36')
    options.add_argument('--disable-infobars')
    options.add_argument('--no-sandbox')
    options.add_argument('--headless')
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    end
  
    Capybara.default_driver = :selenium_chrome_realistic
    Capybara.app_host = "https://notif-dev.valbury.co.id/admin/login"
    Capybara.run_server = false
  
    # Include DSL so we can use visit, click_button, etc.
    include Capybara::DSL
end

def after_run_capybara
  # Close the browser session at the end
Capybara.reset_sessions!
Capybara.current_session.driver.quit
end

def get_otp_by_phone_number(phone_number, var)
  initialize_capybara

  email = "#{ENV['NOTIFICATION_EMAIL']}"
  password = "#{ENV['NOTIFICATION_PASSWORD']}"
  # Start automation
  visit('/')

  puts "Page title is: #{page.title}"

  fill_in 'admin_user_email', with: email
  fill_in 'admin_user_password', with: password
    click_button 'commit'
  find('li#history_log > a').click
  find('li#histories > a').click
  File.write('histories.html', page.html)
  html = File.read('histories.html')
  doc = Nokogiri::HTML(page.html)
  row = doc.at_xpath("//tr[td[contains(@class,'col-phone') and normalize-space(text())='#{phone_number}']]")

  if row
  # Extract id from the tr's id attribute, e.g. id="history_28009"
  row_id_attr = row['id'] # => "history_28009"
  id_from_attr = row_id_attr.split('_').last # => "28009"

  # Alternatively, extract the ID from the link in the id column
  id_link = row.at_xpath(".//td[contains(@class,'col-id')]/a")
  id_from_link = id_link.text.strip if id_link

  puts "ID from row attribute: #{id_from_attr}"
  puts "ID from id column link: #{id_from_link}"

  puts "xx: (//a[@href='/admin/histories/#{id_from_link}'])[1]"
  find(:xpath, "(//a[@href='/admin/histories/#{id_from_link}'])[1]").click

  File.write('otp.html', page.html)

  html = File.read('otp.html')
  doc = Nokogiri::HTML(html)
  otp = doc.at_xpath("//tr[th[text()='Token']]/td").text

  instance_variable_set("@#{var}", otp)

  puts "valid otp: #{otp}"
  else
  puts "Phone number #{phone_number} not found"
  end

  after_run_capybara
end
