Feature: Test All Steps Function

  @TEST_STEP1 @allure.feature:step
  Scenario: [API] Define value as variable
    Given user wait until "0.5" seconds
    When user define value "budi" with variable "username"
    And user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{username}",
        "completed": false
      }
      """
    Then the response status should be "201"

@TEST_STEP @allure.feature:step
  Scenario: [API] Collect data from ENV
    Given user wait until "0.5" seconds
    And user collects data from ENV "VALUE_TEST" as "value_env"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{value_env}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{value_env}"

  @TEST_STEP @allure.feature:step
  Scenario: [API] Direct send body from ENV
    Given user wait until "0.5" seconds
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{ENV:VALUE_TEST}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{ENV:VALUE_TEST}"

    @TEST_STEP @allure.feature:login
  Scenario: [API] Define ENV step
    Given user wait until "0.5" seconds
    When user define env variable "TEST_DATA:TAMBAHAN"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{ENV:TEST_DATA}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{ENV:TEST_DATA}"

    @TEST_STEP @allure.feature:login
  Scenario: [API] Coolect data from response with json
    Given user wait until "0.5" seconds
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{ENV:VALUE_TEST}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{ENV:VALUE_TEST}"
    And user collects data from response with json path "id" as "new_title"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{new_title}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{new_title}"

    @TEST_STEP @allure.feature:login
  Scenario: [API] Generate random text
    Given user generate random text with variable "random_text"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{random_text}",
        "completed": false
      }
      """
    And the response status should be "201"
    Then the response body with json path "title" equal to "{random_text}"

    @TEST_STEP @allure.feature:login
  Scenario: [API] Format date
    Given format date "20 July 2025" to "%Y-%m-%d" and save as variable "formatted_birth_date"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{formatted_birth_date}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{formatted_birth_date}"

    @TEST_STEP @allure.feature:login
  Scenario: [API] Generate Random Integer
    When user generate random integer between "20000000" and "21000000" and save as variable "creation_code"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{creation_code}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{creation_code}"

    @TEST_STEP @allure.feature:login
  Scenario: [API] Generate UUID
    And user generate uuid with variable "udid_id"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{udid_id}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{udid_id}"

    @TEST_STEP @allure.feature:login
  Scenario: [API] Generate Random string
    And user generate random string of "12" characters with variable "random_string"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{random_string}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{random_string}"
  
    @TEST_STEP @allure.feature:login
  Scenario: [API] Extract regex
    And extract string "PESAN OTP ANDA 9876 TOLONG JANGAN DIBAGIKAN KE SIAPAPUN YA!" using regex "(\d+)" as "otp_data"
    When user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{otp_data}",
        "completed": false
      }
      """
    Then the response status should be "201"
    Then the response body with json path "title" equal to "{otp_data}"
