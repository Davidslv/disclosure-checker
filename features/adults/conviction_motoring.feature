Feature: Adult Conviction
  Background:
    Given I am completing a basic 18 or over "Motoring (including motoring fines)" conviction
    Then I should see "What was your motoring conviction?"

  @happy_path @date_travel
  Scenario Outline: Motoring disqualification with length
    Given The current date is 03-07-2020
    When I choose "<subtype>"

    Then I should see "Did you get an endorsement?"
    And I choose "<endorsement>"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2020

    Then I should see "<length_type_header>"
    And  I choose "Months"

    Then I should see "<length_header>"
    And I fill in "Number of months" with "<length_months>"
    And I click the "Continue" button

    Then I should be on "<result>"
    And I should see "<spent_date>"

    Examples:
      | subtype          | endorsement | known_date_header       | length_type_header                                                      | length_header                                | length_months | result               | spent_date                                       |
      | Disqualification | Yes         | When did the ban start? | Was the length of the disqualification given in weeks, months or years? | What was the length of the disqualification? | 6             | /steps/check/results | This conviction will be spent on 1 January 2025  |
      | Disqualification | No          | When did the ban start? | Was the length of the disqualification given in weeks, months or years? | What was the length of the disqualification? | 6             | /steps/check/results | This conviction was spent on 1 July 2020         |
      | Disqualification | Yes         | When did the ban start? | Was the length of the disqualification given in weeks, months or years? | What was the length of the disqualification? | 70            | /steps/check/results | This conviction will be spent on 1 November 2025 |
      | Disqualification | No          | When did the ban start? | Was the length of the disqualification given in weeks, months or years? | What was the length of the disqualification? | 70            | /steps/check/results | This conviction will be spent on 1 November 2025 |

  @happy_path @date_travel
  Scenario Outline: Motoring disqualification without length or indefinite
    Given The current date is 03-07-2020
    When I choose "<subtype>"

    Then I should see "Did you get an endorsement?"
    And I choose "<endorsement>"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2020

    Then I should see "<length_type_header>"
    And  I choose "<length_option>"

    Then I should be on "<result>"
    And I should see "<spent_date>"

    Examples:
      | subtype          | endorsement | known_date_header       | length_type_header                                                      | length_option       | result               | spent_date                                                                         |
      | Disqualification | Yes         | When did the ban start? | Was the length of the disqualification given in weeks, months or years? | No length was given | /steps/check/results | This conviction will be spent on 1 January 2025                                    |
      | Disqualification | No          | When did the ban start? | Was the length of the disqualification given in weeks, months or years? | No length was given | /steps/check/results | This conviction will be spent on 1 January 2022                                    |
      | Disqualification | Yes         | When did the ban start? | Was the length of the disqualification given in weeks, months or years? | Until further order | /steps/check/results | This conviction will stay in place until another order is made to change or end it |
      | Disqualification | No          | When did the ban start? | Was the length of the disqualification given in weeks, months or years? | Until further order | /steps/check/results | This conviction will stay in place until another order is made to change or end it |

  @happy_path  @date_travel
  Scenario Outline: Motoring fine
    Given The current date is 03-07-2020
    When I choose "<subtype>"

    Then I should see "Did you get an endorsement?"
    And I choose "<endorsement>"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2020
    Then I should be on "<result>"
    And I should see "<spent_date>"

    Examples:
      | subtype                    | endorsement | known_date_header                        | result               | spent_date                                      |
      | Fine                       | Yes         | When were you given the fine?            | /steps/check/results | This conviction will be spent on 1 January 2025 |
      | Fine                       | No          | When were you given the fine?            | /steps/check/results | This conviction will be spent on 1 January 2021 |

  @happy_path @date_travel
  Scenario Outline: Motoring penalty points
    Given The current date is 03-07-2020
    When I choose "<subtype>"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2020

    Then I should be on "<result>"
    And I should see "This conviction <spent_date>"

    Examples:
      | subtype                    | known_date_header                        | result               | spent_date                      |
      | Penalty points             | When were you given the penalty points?  | /steps/check/results | will be spent on 1 January 2025 |
