Feature: Create a brewer

  In order to provide more information about a beer
  As an API client
  I want to be able to create brewers via the API

  Background:
    Given a user exists with a token of "a1b2c3"

  Scenario Outline:
    When I send an API POST request to /v1/brewers.<format>?token=<token>
      """
      <body>
      """
    Then I should receive a <status> response

  Examples:
    | body                                | token  | status | format |
    | { "brewer" : { "name" : "Abita" } } | a1b2c3 | 201    | json   |
    | { "brewer" : {} }                   | a1b2c3 | 400    | json   |
    | {}                                  | a1b2c3 | 400    | json   |
    |                                     | a1b2c3 | 400    | json   |
    | { "brewer" : { "name" : "Abita" } } | a1b2c3 | 406    | xml    |
    | { "brewer" : { "name" : "Abita" } } |        | 401    | json   |
    | { "brewer" : {} }                   |        | 401    | json   |
    | {}                                  |        | 401    | json   |
    |                                     |        | 401    | json   |
    | { "brewer" : { "name" : "Abita" } } |        | 401    | xml    |

  Scenario: Creating a brewer successfully
    When I create the following brewer via the API using the "a1b2c3" token:
      | name     |
      | Pumpking |
    Then the following brewer should exist:
      | user          | name     |
      | token: a1b2c3 | Pumpking |

  Scenario: Creating a brewer unsuccessfully
    When I create the following brewer via the API using the "a1b2c3" token:
      | name |
      |      |
    Then the "a1b2c3" API user should have 0 brewers
