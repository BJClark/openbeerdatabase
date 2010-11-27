Feature: List beers

  In order to use the database in my application
  As an API client
  I want to be able to list beers

  Scenario: Listing beers, with all the default options
    Given the following beers exist:
      | id | user          | name               |
      | 1  |               | Pumpking           |
      | 2  |               | Strawberry Harvest |
      | 3  | token: a1b2c3 | Pliney the Elder   |
    When I send an API GET request to /v1/beers
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"  : 1,
          "beers" : [
            { "id" : 1, "name" : "Pumpking" },
            { "id" : 2, "name" : "Strawberry Harvest" }
          ]
        }
      """

  Scenario: Listing beers, with pagination
    Given the following beers exist:
      | id | user          | name               |
      | 1  |               | Pumpking           |
      | 2  | token: a1b2c3 | Pliney the Elder   |
      | 3  |               | Strawberry Harvest |
    When I send an API GET request to /v1/beers?page=2&per_page=1
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"  : 2,
          "beers" : [
            { "id" : 3, "name" : "Strawberry Harvest" }
          ]
        }
      """

  Scenario: Listing beers, with entries from an API client
    Given the following beers exist:
      | id | user          | name               |
      | 1  |               | Pumpking           |
      | 2  |               | Strawberry Harvest |
      | 3  | token: a1b2c3 | Pliney the Elder   |
    When I send an API GET request to /v1/beers?token=a1b2c3
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"  : 1,
          "beers" : [
            { "id" : 1, "name" : "Pumpking" },
            { "id" : 2, "name" : "Strawberry Harvest" },
            { "id" : 3, "name" : "Pliney the Elder" }
          ]
        }
      """
