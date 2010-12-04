Feature: Create a new user

  In order to create records via the API
  As a visitor
  I want to be able to create a user

  Scenario: Requesting an API token
    Given I am on the homepage
    When I follow "Request an API token."
    Then I should see the API token request form element
