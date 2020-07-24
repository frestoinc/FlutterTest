Feature: Login Page Validates with Error

  Scenario: When email and password are entered and button is clicked
    Given I have "login_email_field" and "login_pwd_field" and "login_btn_idle" widgets
    When I fill "login_email_field" with "abc@123.com"
    And I fill "login_pwd_field" with "123456"
    When I tap "login_btn_idle"
    Then "login_snackbar" should be shown on page