Ability:
  As a visitor, I can create a new account if
  the email I provide isn't already in use.

  Scenario: Happy path
    Given Matthieu's email isn't already in use
    When Matthieu attempts to create a new account using "his" email
    Then Matthieu's account is "succesfully" created

  Scenario: Can't create account if the email is already in use
    Given Elodie has an account
    When Matthieu attempts to create a new account using "Elodie's" email
    Then Matthieu is notified about the conflict
      And Matthieu's account is "not" created
