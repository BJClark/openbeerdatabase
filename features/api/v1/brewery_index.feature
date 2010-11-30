Feature: List breweries

  In order to use the database in my application
  As an API client
  I want to be able to list breweries

  Background:
    Given the following breweries exist:
      | id | user          | name          | created_at | updated_at |
      | 1  |               | Southern Tier | 2010-01-01 | 2010-02-02 |
      | 2  | token: a1b2c3 | Abita         | 2010-03-03 | 2010-04-04 |
      | 3  |               | Russian River | 2010-05-05 | 2010-06-06 |

  Scenario: Listing breweries
    When I send an API GET request to /v1/breweries.json
    Then I should receive a 200 response
    And I should see the following JSON response
      """
        { "page"      : 1,
          "pages"     : 1,
          "total"     : 2,
          "breweries" : [
            { "id"         : 1,
              "name"       : "Southern Tier",
              "created_at" : "2010-01-01T00:00:00Z",
              "updated_at" : "2010-02-02T00:00:00Z"
            },
            { "id"         : 3,
              "name"       : "Russian River",
              "created_at" : "2010-05-05T00:00:00Z",
              "updated_at" : "2010-06-06T00:00:00Z"
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
            { "id"         : 3,
              "name"       : "Russian River",
              "created_at" : "2010-05-05T00:00:00Z",
              "updated_at" : "2010-06-06T00:00:00Z"
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
            { "id"         : 1,
              "name"       : "Southern Tier",
              "created_at" : "2010-01-01T00:00:00Z",
              "updated_at" : "2010-02-02T00:00:00Z"
            },
            { "id"         : 2,
              "name"       : "Abita",
              "created_at" : "2010-03-03T00:00:00Z",
              "updated_at" : "2010-04-04T00:00:00Z"
            },
            { "id"         : 3,
              "name"       : "Russian River",
              "created_at" : "2010-05-05T00:00:00Z",
              "updated_at" : "2010-06-06T00:00:00Z"
            }
          ]
        }
      """

  Scenario: Listing breweries, in an invalid format
    When I send an API GET request to /v1/breweries.xml
    Then I should receive a 406 response
