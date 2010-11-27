Feature: Create a beer

  In order to build a database of beers
  As an API client
  I want to be able to create beers via the API

  Background:
    Given the following user exists:
      | token  |
      | a1b2c3 |

  Scenario Outline:
    When I send an API POST request to /v1/beers.json?token=<token>
      """
      <body>
      """
    Then I should receive a <status> response

  Examples:
    | body                                 | token  | status |
    | { "beer" : { "name" : "Pumpking" } } | a1b2c3 | 201    |
    | { "beer" : {} }                      | a1b2c3 | 400    |
    | {}                                   | a1b2c3 | 400    |
    |                                      | a1b2c3 | 400    |
    | { "beer" : { "name" : "Pumpking" } } |        | 401    |
    | { "beer" : {} }                      |        | 401    |
    | {}                                   |        | 401    |
    |                                      |        | 401    |

  Scenario: Creating a beer successfully
    When I create the following beer via the API using the "a1b2c3" token:
      | name     |
      | Pumpking |
    Then the following beer should exist:
      | user          | name     |
      | token: a1b2c3 | Pumpking |

  Scenario: Creating a beer unsuccessfully
    When I create the following beer via the API using the "a1b2c3" token:
      | name |
      |      |
    Then the "a1b2c3" API user should have 0 beers
