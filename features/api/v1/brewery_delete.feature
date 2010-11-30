Feature: Delete a brewery

  In order to remove unwanted breweries
  As an API client
  I want to be able to delete breweries via the API

  Background:
    Given a user exists with a token of "a1b2c3"

  Scenario: Deleting a brewery owned by the requesting API client
    Given the following brewery exists:
      | id | user          | name  |
      | 1  | token: a1b2c3 | Abita |
    When I send an API DELETE request to /v1/breweries/1.json?token=a1b2c3
    Then I should receive a 200 response
    And the "a1b2c3" API user should have 0 breweries

  Scenario: Attempting to delete a brewery not owned by the requesting API client
    Given the following brewery exists:
      | id | user          | name  |
      | 1  | token: d4e5f6 | Abita |
    When I send an API DELETE request to /v1/breweries/1.json?token=a1b2c3
    Then I should receive a 401 response
    And the "d4e5f6" API user should have 1 breweries

  Scenario: Attempting to delete a brewery not owned by an API client
    Given the following brewery exists:
      | id | user | name  |
      | 1  |      | Abita |
    When I send an API DELETE request to /v1/breweries/1.json?token=a1b2c3
    Then I should receive a 401 response
    And the following brewery should exist:
      | id | name  |
      | 1  | Abita |

  Scenario: Attempting to delete a brewery with beers
    Given the following brewery exists:
      | id | user          | name  |
      | 1  | token: a1b2c3 | Abita |
    And the following beer exists:
      | brewery     | user          | name  |
      | name: Abita | token: a1b2c3 | Amber |
    When I send an API DELETE request to /v1/breweries/1.json?token=a1b2c3
    Then I should receive a 400 response
    And the "a1b2c3" API user should have 1 breweries
    And the "a1b2c3" API user should have 1 beers
