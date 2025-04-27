# API Automation Test Framework

> **A lightweight, low-code API automation framework designed to streamline API testing and ensure high-quality software through automated test execution.** 

This framework is designed to help testers and developers automate API testing with minimal configuration. It provides an easy-to-use set of tools to create, execute, and validate API tests while ensuring integration with other tools like **Allure Report** for seamless test reporting. 

### Key Features of the Framework:
- **API Method Support**: The framework supports key HTTP methods: `GET`, `POST`, `PUT`, `DELETE`, and `PATCH`, allowing for a full range of API testing.
- **Status Code Validation**: Easily validate if the API response status matches the expected values, ensuring the API functions as intended.
- **JSON Path Validation**: The framework supports validating the content of the response using JSON path, which allows for detailed checks on API responses.
- **JSON & XML Schema Validation**: Validate the API response structure against predefined **JSON Schema** and **XML Schema** files located in the `contracts/` folder to ensure the response conforms to expected formats.
- **API Chaining**: Supports chaining multiple API requests by using data from a previous response in subsequent requests, making testing of complex workflows straightforward.
- **Response Time Monitoring**: Track the response time of API calls and ensure they meet the required performance thresholds.
- **Allure Reporting**: Generate visually appealing and comprehensive test reports with Allure, which helps teams track test execution and results.

This framework allows for greater efficiency, speed, and reliability in testing APIs by automating repetitive tasks, enabling faster feedback, and reducing human error.

# List of Content

* [API Automation Test Framework Feature](#api-automation-test-framework-feature)
* [API Automation Test Architecture](#api-automation-test-architecture)
* [Setup](#setup)
  * [rbenv Installation](#rbenv-installation)
  * [Ruby Installation](#ruby-installation)
  * [Bundle Install (Install all dependencies)](#bundle-install-install-all-dependencies)
  * [Running Test](#running-test)
  * [Running Test with Allure Report](#running-test-with-allure-report)
* [How to Write Test](#how-to-write-test)
  * [Basic Gherkin Example](#basic-gherkin-example)
  * [API Chaining Example](#api-chaining-example)
* [Contributing](#contributing)
* [License](#license)

# API Automation Test Framework Feature

> A lightweight, low-code API automation framework designed to make API testing efficient, flexible, and easy to maintain.

- Supports API methods: `GET`, `POST`, `PUT`, `DELETE`, and `PATCH`
- Supports validation of API response `status code`
- Supports validation of API response using `JSON Path`
- Supports response validation against `JSON Schema` and `XML Schema` by defining contracts in the `contracts/` folder
- Supports `API Chaining` (using data from previous responses for subsequent requests)
- Supports monitoring of `API Response Time`
- Supports beautiful reporting using `Allure Report`

# API Automation Test Architecture

- [Documentation](docs/main.md) (Coming soon)

# Setup

## rbenv installation

```shell
brew install rbenv
rbenv init
```

[Detail installation](https://github.com/rbenv/rbenv)

## Ruby Installation

* Once rbenv is installed, you can install Ruby 3.4.1 by running the following command:

```shell
rbenv install 3.4.1
rbenv global 3.4.1
```

## Bundle Install (Install all Automation Test Dependencies)

* In order to install the dependencies for your project, navigate to the project directory and run:

```shell
bundle install
```

Ensure no errors occur after running `bundle install`

## Running Test

* Create `.env` file and add the following mandatory variable like account, base url, and any other required variables on scenario

* To run tests, you can use the following command:

```shell
#to run specific scenario by tag and create allure result & cucumber report
cucumber --tag @NAME_TAG

#to run specific scenario by tag and create allure result without cucumber report
cucumber --tag @NAME_TAG -p without-cucumber-report
```

## Running Test with Allure Report

To generate and view the Allure report after running tests:

After the test run, generate the report files:

```shell
allure generate --clean
```

Serve the report to view it on browser:

```shell
allure open
```

> Make sure you have installed the Allure CLI. If not, you can install it via brew install allure (Mac) or follow [this guide](https://allurereport.org/docs/install/).

## How to Write Test

### Basic Gherkin Example
Example of basic scenario validating status code and JSON path:

```gherkin
Feature: User Login API

  Scenario: Collect data from ENV
    Given user sends a POST request to "{ENV:BASE_URL}/todos" with body:
      """
      {
        "userId": 1,
        "title": "{ENV:TITLE}",
        "completed": false
      }
      """
    Then the response status should be "200"
    Then the response body with json path "title" equal to "{ENV:TITLE}"
```

### API Chaining Example

Using data from a previous API for the next request:

```gherkin
Feature: User Login API

  Scenario: Successful login with valid credentials
    Given user define value "user@example.com" with variable "email"
    When user define value "password123" with variable "password"
    And user sends a POST request to "{ENV:BASE_URL}/api/login" with body:
      """
      {
        "email": "{email}",
        "password": "{password}"
      }
      """
    Then the response status should be "200"
    Then the response body with json path "message" equal to "Login Berhasil"
    And user collects data from response with json path "token" as "token"
    And user set header as:
    """
    {
        "Authorization": "Bearer {token}"
    }
    """
    And user sends a GET request to "{ENV:BASE_URL}/api/profile"
    And the response status should be "200"
    Then the response body with json path "status" equal to "get profile success"
```   
> {{created_order_id}} will automatically be replaced by the saved value from the first API.

## Contributing

- Fork and clone the repository.
- Create a new branch for your feature or bugfix.
- Make your changes and run the tests.
- Push your branch and create a Merge Request.
- Update or add documentation if needed.

> We welcome contributions of all kinds, whether it's new features, bug fixes, or improvements!

## License

This project is licensed under the MIT License.
