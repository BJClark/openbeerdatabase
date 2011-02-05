Feature: Create a brewery

  In order to provide more information about a beer
  As an API client
  I want to be able to create breweries via the API

  Background:
    Given a user exists with a token of "a1b2c3"

  Scenario Outline:
    When I send an API POST request to /v1/breweries.<format>?token=<token>
      """
      <body>
      """
    Then I should receive a <status> response

  Examples:
    | body                                 | token  | status | format |
    | { "brewery" : { "name" : "Abita" } } | a1b2c3 | 201    | json   |
    | { "brewery" : {} }                   | a1b2c3 | 400    | json   |
    | {}                                   | a1b2c3 | 400    | json   |
    |                                      | a1b2c3 | 400    | json   |
    | { "brewery" : { "name" : "Abita" } } | a1b2c3 | 406    | xml    |
    | { "brewery" : { "name" : "Abita" } } |        | 401    | json   |
    | { "brewery" : {} }                   |        | 401    | json   |
    | {}                                   |        | 401    | json   |
    |                                      |        | 401    | json   |
    | { "brewery" : { "name" : "Abita" } } |        | 401    | xml    |

  Scenario: Creating a brewery
    When I create the following brewery via the API using the "a1b2c3" token:
      | name          |
      | Southern Tier |
    Then I should receive a 201 response
    And the Location header should be set to the API brewery page for "Southern Tier"
    And the following brewery should exist:
      | user          | name          |
      | token: a1b2c3 | Southern Tier |

  Scenario: Creating a brewery, with validation errors
    When I create the following brewery via the API using the "a1b2c3" token:
      | name | url |
      |      | WTF |
    Then I should receive a 400 response
    And I should see JSON:
      """
        { "errors" : {
            "name" : ["can't be blank"],
            "url"  : ["is invalid"]
          }
        }
      """
