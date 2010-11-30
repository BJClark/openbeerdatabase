Feature: View a beer

  In order to see details on a beer
  As an API client
  I want to be able to view a beer

  Background:
    Given the following breweries exist:
      | id | name  |
      | 1  | Abita |

  Scenario: Viewing a beer
    Given the following beer exists:
      | id | user | brewery             | name               | description | abv | created_at | updated_at |
      | 1  |      | name: Abita         | Strawberry Harvest | Southern.   | 4.2 | 2010-01-01 | 2010-02-02 |
    When I send an API GET request to /v1/beers/1.json
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "id"          : 1,
          "name"        : "Strawberry Harvest",
          "description" : "Southern.",
          "abv"         : 4.2,
          "created_at"  : "2010-01-01T00:00:00Z",
          "updated_at"  : "2010-02-02T00:00:00Z",
          "brewery"     : {
            "id"   : 1,
            "name" : "Abita"
          }
        }
      """

  Scenario: Viewing a beer, not owned by the requesting API client
    Given the following beer exists:
      | id | user          | brewery             | name               | description | abv | created_at | updated_at |
      | 1  | token: a1b2c3 | name: Abita         | Strawberry Harvest | Southern.   | 4.2 | 2010-01-01 | 2010-02-02 |
    When I send an API GET request to /v1/beers/1.json?token=d4e5f6
    Then I should receive a 401 response

  Scenario: Viewing a beer, that does not exist
    When I send an API GET request to /v1/beers/1.json
    Then I should receive a 404 response

  Scenario: Viewing a beer, in an invalid format
    Given the following beer exists:
      | id |
      | 1  |
    When I send an API GET request to /v1/beers/1.xml
    Then I should receive a 406 response
