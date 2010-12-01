Feature: View a brewery

  In order to see details on a brewery
  As an API client
  I want to be able to view a brewery

  Scenario: Viewing a brewery
    Given the following brewery exists:
      | id | name  | url              | created_at | updated_at |
      | 1  | Abita | http://abita.com | 2010-01-01 | 2010-02-02 |
    When I send an API GET request to /v1/breweries/1.json
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "id"         : 1,
          "name"       : "Abita",
          "url"        : "http://abita.com",
          "created_at" : "2010-01-01T00:00:00Z",
          "updated_at" : "2010-02-02T00:00:00Z"
        }
      """

  Scenario: Viewing a brewery, with JSONP
    Given the following brewery exists:
      | id | name  | url              | created_at | updated_at |
      | 1  | Abita | http://abita.com | 2010-01-01 | 2010-02-02 |
    When I send an API GET request to /v1/breweries/1.json?callback=onBrewery
    Then I should receive a 200 response
    And I should see the following JSONP response with an "onBrewery" callback
      """
        { "id"         : 1,
          "name"       : "Abita",
          "url"        : "http://abita.com",
          "created_at" : "2010-01-01T00:00:00Z",
          "updated_at" : "2010-02-02T00:00:00Z"
        }
      """

  Scenario: Viewing a brewery, not owned by the requesting API client
    Given the following brewery exists:
      | id | user          |
      | 1  | token: a1b2c3 |
    When I send an API GET request to /v1/breweries/1.json?token=d4e5f6
    Then I should receive a 401 response

  Scenario: Viewing a brewery, that does not exist
    When I send an API GET request to /v1/breweries/1.json
    Then I should receive a 404 response

  Scenario: Viewing a brewery, in an invalid format
    Given the following brewery exists:
      | id |
      | 1  |
    When I send an API GET request to /v1/breweries/1.xml
    Then I should receive a 406 response
