Feature: Create a beer

  In order to build a database of beers
  As an API client
  I want to be able to create beers via the API

  Background:
    Given a user exists with a token of "a1b2c3"

  Scenario Outline:
    When I send an API POST request to /v1/beers.<format>?token=<token>
      """
      <body>
      """
    Then I should receive a <status> response

  Examples:
    | body            | token  | status | format |
    | { "beer" : {} } | a1b2c3 | 400    | json   |
    | {}              | a1b2c3 | 400    | json   |
    |                 | a1b2c3 | 400    | json   |
    | { "beer" : {} } | a1b2c3 | 406    | xml    |
    | { "beer" : {} } |        | 401    | json   |
    | {}              |        | 401    | json   |
    |                 |        | 401    | json   |
    | { "beer" : {} } |        | 401    | xml    |

  Scenario: Creating a beer
    Given the following brewery exists:
      | user          | name  |
      | token: a1b2c3 | Abita |
    When I create the following beer via the API for the "Abita" brewery using the "a1b2c3" token:
      | name  | description | abv |
      | Amber | Common.     | 4.5 |
    Then I should receive a 201 response
    And the Location header should be set to the API beer page for "Amber"
    And the following beer should exist:
      | user          | brewery     | name  | description | abv |
      | token: a1b2c3 | name: Abita | Amber | Common.     | 4.5 |

  Scenario: Creating a beer, with a brewery not owned by the requesting API client
    Given a brewery exists with a name of "Southern Tier"
    When I create the following beer via the API for the "Southern Tier" brewery using the "a1b2c3" token:
      | name     |
      | Pumpking |
    Then I should receive a 400 response
    And the "a1b2c3" API user should have 0 beers

  Scenario: Creating a beer, with validation errors
    Given a brewery exists with a name of "Southern Tier"
    When I create the following beer via the API for the "Southern Tier" brewery using the "a1b2c3" token:
      | name | abv | description |
      |      | WTF |             |
    Then I should receive a 400 response
    And I should see the following JSON response:
      """
        { "errors" : {
            "brewery_id"  : "can't be blank",
            "name"        : "can't be blank",
            "abv"         : "is not a number",
            "description" : "can't be blank"
          }
        }
      """
