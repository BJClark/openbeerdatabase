Feature: Delete a beer

  In order to remove unwanted beers
  As an API client
  I want to be able to delete beers via the API

  Background:
    Given a user exists with a token of "a1b2c3"

  Scenario: Deleting a beer
    Given the following beer exists:
      | id | user          |
      | 1  | token: a1b2c3 |
    When I send an API DELETE request to /v1/beers/1?token=a1b2c3
    Then I should receive a 200 response
    And the "a1b2c3" API user should have 0 beers

  Scenario: Deleting a beer, not owned by the requesting API client
    Given the following beer exists:
      | id | user          |
      | 1  | token: d4e5f6 |
    When I send an API DELETE request to /v1/beers/1?token=a1b2c3
    Then I should receive a 401 response
    And the "d4e5f6" API user should have 1 beers

  Scenario: Deleting a beer, not owned by an API client
    Given the following beer exists:
      | id | user | name     |
      | 1  |      | Pumpking |
    When I send an API DELETE request to /v1/beers/1?token=a1b2c3
    Then I should receive a 401 response
    And the following beer should exist:
      | id | name     |
      | 1  | Pumpking |

  Scenario: Deleting a beer, that does not exist
    When I send an API DELETE request to /v1/beers/1.json?token=a1b2c3
    Then I should receive a 404 response
