Feature: List brewers

  In order to use the database in my application
  As an API client
  I want to be able to list brewers

  Background:
    Given the following brewers exist:
      | id | user          | name          |
      | 1  |               | Southern Tier |
      | 2  | token: a1b2c3 | Abita         |
      | 3  |               | Russian River |

  Scenario: Listing brewers, with all the default options
    When I send an API GET request to /v1/brewers.json
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"    : 1,
          "brewers" : [
            { "id"   : 1,
              "name" : "Southern Tier"
            },
            { "id"   : 3,
              "name" : "Russian River"
            }
          ]
        }
      """

  Scenario: Listing brewers, with pagination
    When I send an API GET request to /v1/brewers.json?page=2&per_page=1
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"    : 2,
          "brewers" : [
            { "id"   : 3,
              "name" : "Russian River"
            }
          ]
        }
      """

  Scenario: Listing brewers, with entries from an API client
    When I send an API GET request to /v1/brewers.json?token=a1b2c3
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"    : 1,
          "brewers" : [
            { "id"     : 1,
              "name"   : "Southern Tier"
            },
            { "id"     : 2,
              "name"   : "Abita"
            },
            { "id"     : 3,
              "name"   : "Russian River"
            }
          ]
        }
      """
