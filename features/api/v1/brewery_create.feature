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

  Scenario: Creating a brewery successfully
    When I create the following brewery via the API using the "a1b2c3" token:
      | name     |
      | Pumpking |
    Then the following brewery should exist:
      | user          | name     |
      | token: a1b2c3 | Pumpking |

  Scenario: Creating a brewery unsuccessfully
    When I create the following brewery via the API using the "a1b2c3" token:
      | name |
      |      |
    Then the "a1b2c3" API user should have 0 breweries
