Feature: Google Translate

  Scenario: Perform a single word translation
    Given I am on the Google Translate page
    When I set the source language
    And I set the target language
    And I enter the source language phrase
    Then the target language phrase should be correctly translated

  Scenario: Perform a word translation, then swap languages
    Given I have entered a phrase on the Google Translate page
    When I click the Swap Languages button
    Then the source language phrase should be correctly translated

  Scenario: Perform a word translation, then swap languages, then enter a phrase using the on-screen keyboard
    Given I have entered a phrase on the Google Translate page
    When I clear the source language field
    And I enter a phrase using the on-screen keyboard
    Then the keyboard phrase should be correctly translated