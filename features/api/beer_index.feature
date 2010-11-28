Feature: List beers

  In order to use the database in my application
  As an API client
  I want to be able to list beers

  Background:
    Given the following brewers exist:
      | id | name          |
      | 1  | Southern Tier |
      | 2  | Abita         |
      | 3  | Russian River |
    And the following beers exist:
      | id | user          | brewer              | name               |
      | 1  |               | name: Southern Tier | Pumpking           |
      | 2  | token: a1b2c3 | name: Russian River | Pliney the Elder   |
      | 3  |               | name: Abita         | Strawberry Harvest |

  Scenario: Listing beers, with all the default options
    When I send an API GET request to /v1/beers.json
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"  : 1,
          "beers" : [
            { "id"     : 1,
              "name"   : "Pumpking",
              "brewer" : {
                "id"   : 1,
                "name" : "Southern Tier"
              }
            },
            { "id"     : 3,
              "name"   : "Strawberry Harvest",
              "brewer" : {
                "id"   : 2,
                "name" : "Abita"
              }
            }
          ]
        }
      """

  Scenario: Listing beers, with pagination
    When I send an API GET request to /v1/beers.json?page=2&per_page=1
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"  : 2,
          "beers" : [
            { "id"     : 3,
              "name"   : "Strawberry Harvest",
              "brewer" : {
                "id"   : 2,
                "name" : "Abita"
              }
            }
          ]
        }
      """

  Scenario: Listing beers, with entries from an API client
    When I send an API GET request to /v1/beers.json?token=a1b2c3
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"  : 1,
          "beers" : [
            { "id"     : 1,
              "name"   : "Pumpking",
              "brewer" : {
                "id"   : 1,
                "name" : "Southern Tier"
              }
            },
            { "id"     : 2,
              "name"   : "Pliney the Elder",
              "brewer" : {
                "id"   : 3,
                "name" : "Russian River"
              }
            },
            { "id"     : 3,
              "name"   : "Strawberry Harvest",
              "brewer" : {
                "id"   : 2,
                "name" : "Abita"
              }
            }
          ]
        }
      """
