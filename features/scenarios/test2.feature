Feature: request response Test

@TEST2
Scenario: Login 
  Given user set header as:
  """
  {
    "x-api-key": "reqres-free-v1"
  }
  """
  Given user sends a POST request to "{ENV:BASE_URL}/api/login"
    """
    {
      "username": "eve.holt@reqres.in",
      "password": "cityslicka"
    }
    """
  Then the response status should be "200"
