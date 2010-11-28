Feature: Create a beer

  In order to build a database of beers
  As an API client
  I want to be able to create beers via the API

  Background:
    Given a user exists with a token of "a1b2c3"
    And the following brewer exists:
      | id | name  |
      | 1  | Abita |

  Scenario Outline:
    When I send an API POST request to /v1/beers.json?token=<token>
      """
      <body>
      """
    Then I should receive a <status> response

  Examples:
    | body                                                  | token  | status |
    | { "beer" : { "brewer_id" : 1, "name" : "Pumpking" } } | a1b2c3 | 201    |
    | { "beer" : {} }                                       | a1b2c3 | 400    |
    | {}                                                    | a1b2c3 | 400    |
    |                                                       | a1b2c3 | 400    |
    | { "beer" : { "brewer_id" : 1, "name" : "Pumpking" } } |        | 401    |
    | { "beer" : {} }                                       |        | 401    |
    | {}                                                    |        | 401    |
    |                                                       |        | 401    |

  Scenario: Creating a beer successfully
    When I create the following beer via the API using the "a1b2c3" token:
      | brewer_id | name     |
      | 1         | Pumpking |
    Then the following beer should exist:
      | user          | brewer      | name     |
      | token: a1b2c3 | name: Abita | Pumpking |

  Scenario: Creating a beer unsuccessfully
    When I create the following beer via the API using the "a1b2c3" token:
      | name |
      |      |
    Then the "a1b2c3" API user should have 0 beers
