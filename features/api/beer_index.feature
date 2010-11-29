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
      | id | user          | brewer              | name               | description | abv |
      | 1  |               | name: Southern Tier | Pumpking           | Seasonal.   | 8.8 |
      | 2  | token: a1b2c3 | name: Russian River | Pliney the Elder   | Rare.       | 8.0 |
      | 3  |               | name: Abita         | Strawberry Harvest | Southern.   | 4.2 |

  Scenario: Listing beers, with all the default options
    When I send an API GET request to /v1/beers.json
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"  : 1,
          "pages" : 1,
          "total" : 2,
          "beers" : [
            { "id"          : 1,
              "name"        : "Pumpking",
              "description" : "Seasonal.",
              "abv"         : 8.8,
              "brewer"      : {
                "id"   : 1,
                "name" : "Southern Tier"
              }
            },
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "brewer"      : {
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
          "pages" : 2,
          "total" : 2,
          "beers" : [
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "brewer"      : {
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
          "pages" : 1,
          "total" : 3,
          "beers" : [
            { "id"          : 1,
              "name"        : "Pumpking",
              "description" : "Seasonal.",
              "abv"         : 8.8,
              "brewer"      : {
                "id"   : 1,
                "name" : "Southern Tier"
              }
            },
            { "id"          : 2,
              "name"        : "Pliney the Elder",
              "description" : "Rare.",
              "abv"         : 8.0,
              "brewer"      : {
                "id"   : 3,
                "name" : "Russian River"
              }
            },
            { "id"          : 3,
              "name"        : "Strawberry Harvest",
              "description" : "Southern.",
              "abv"         : 4.2,
              "brewer"      : {
                "id"   : 2,
                "name" : "Abita"
              }
            }
          ]
        }
      """
