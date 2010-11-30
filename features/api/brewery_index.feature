Feature: List breweries

  In order to use the database in my application
  As an API client
  I want to be able to list breweries

  Background:
    Given the following breweries exist:
      | id | user          | name          |
      | 1  |               | Southern Tier |
      | 2  | token: a1b2c3 | Abita         |
      | 3  |               | Russian River |

  Scenario: Listing breweries, with all the default options
    When I send an API GET request to /v1/breweries.json
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"      : 1,
          "pages"     : 1,
          "total"     : 2,
          "breweries" : [
            { "id"   : 1,
              "name" : "Southern Tier"
            },
            { "id"   : 3,
              "name" : "Russian River"
            }
          ]
        }
      """

  Scenario: Listing breweries, with pagination
    When I send an API GET request to /v1/breweries.json?page=2&per_page=1
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"      : 2,
          "pages"     : 2,
          "total"     : 2,
          "breweries" : [
            { "id"   : 3,
              "name" : "Russian River"
            }
          ]
        }
      """

  Scenario: Listing breweries, with entries from an API client
    When I send an API GET request to /v1/breweries.json?token=a1b2c3
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"      : 1,
          "pages"     : 1,
          "total"     : 3,
          "breweries" : [
            { "id"   : 1,
              "name" : "Southern Tier"
            },
            { "id"   : 2,
              "name" : "Abita"
            },
            { "id"   : 3,
              "name" : "Russian River"
            }
          ]
        }
      """
