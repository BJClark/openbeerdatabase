Feature: Create a beer

  In order to build a database of beers
  As an API client
  I want to be able to create beers via the API

  Background:
    Given a user exists with a token of "a1b2c3"
    And the following brewery exists:
      | id | user          | name  |
      | 2  | token: a1b2c3 | Abita |

  Scenario Outline:
    When I send an API POST request to /v1/breweries/2/beers.<format>?token=<token>
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

  Scenario: Creating a beer successfully
    When I create the following beer via the API for the "Abita" brewery using the "a1b2c3" token:
      | name     | description | abv |
      | Pumpking | Seasonal.   | 8.8 |
    Then I should receive a 201 response
    And the following beer should exist:
      | user          | brewery     | name     | description | abv |
      | token: a1b2c3 | name: Abita | Pumpking | Seasonal.   | 8.8 |

  Scenario: Creating a beer unsuccessfully
    When I create the following beer via the API for the "Abita" brewery using the "a1b2c3" token:
      | name |
      |      |
    Then I should receive a 400 response
    And the "a1b2c3" API user should have 0 beers

  Scenario: Attempting to create a beer with a brewery not owned by the requesting API client
    Given a brewery exists with a name of "Southern Tier"
    When I create the following beer via the API for the "Southern Tier" brewery using the "a1b2c3" token:
      | name     | description | abv |
      | Pumpking | Seasonal.   | 8.8 |
    Then I should receive a 400 response
    And the "a1b2c3" API user should have 0 beers
