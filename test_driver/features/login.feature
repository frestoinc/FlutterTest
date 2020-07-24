Feature: Login Page Validates with Error

  Scenario: login fail - invalid email and password format
    Given I have "login_email_field" and "login_pwd_field" and "login_btn_idle" widgets
    When user enter "abc@123" in "login_email_field"
    And user enter "12345" in "login_pwd_field"
    When user tap "login_btn_idle"
    Then "Exception: Invalid Credentials" should show