Feature: Conviction
  Background:
    When I am completing a basic 18 or over "Financial penalty" conviction

  @happy_path
  Scenario: Conviction Financial penalty - Fine
    When I choose "A fine"
    Then I should see "When were you given the order?"
    When I enter a valid date
    Then I should be on "/steps/check/results"

  @happy_path
  Scenario: Conviction Financial penalty - When compensation paid in full is over £100
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "Yes"
    Then I should see "Was the compensation order amount over £100?"
    And I choose "Yes"
    Then I should see "When did you pay the compensation in full?"
    When I enter a valid date
    Then I should see "Did you send the payment receipt to the Disclosure and Barring (DBS) service?"
    And I choose "Yes"

    Then I should be on "/steps/check/results"

  @happy_path
  Scenario: Conviction Financial penalty - Compensation paid in full is under £100
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "Yes"

    Then I should see "Was the compensation order amount over £100?"
    And I choose "No"

    Then I should see "When did you pay the compensation in full?"
    When I enter a valid date

    Then I should be on "/steps/check/results"

  Scenario: Conviction Financial penalty - Does not select a radio button on over £100 screen
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "Yes"

    Then I should see "Was the compensation order amount over £100?"
    And I click the "Continue" button

    Then I should see "Select yes or no"

  @happy_path
  Scenario: Conviction Financial penalty - Did not send payment receipt
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "Yes"

    Then I should see "Was the compensation order amount over £100?"
    And I choose "Yes"

    Then I should see "When did you pay the compensation in full?"
    When I enter a valid date

    Then I should see "Did you send the payment receipt to the Disclosure and Barring (DBS) service?"
    And I choose "No"

    Then I should be on "/steps/conviction/compensation_unable_to_tell"

  Scenario: Conviction Financial penalty - Does not select radio button on DBS screen
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "Yes"

    Then I should see "Was the compensation order amount over £100?"
    And I choose "Yes"

    Then I should see "When did you pay the compensation in full?"
    When I enter a valid date

    Then I should see "Did you send the payment receipt to the Disclosure and Barring (DBS) service?"
    And I click the "Continue" button

    Then I should see "Select yes or no"

  @happy_path
  Scenario: Conviction Financial penalty - Compensation not paid in full
    When I choose "Compensation to a victim"
    Then I should see "Have you paid the compensation in full?"
    And I choose "No"
    Then I should be on "/steps/conviction/compensation_not_paid"
