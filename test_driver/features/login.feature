Feature: Login Page Validation

  Scenario: login fail - invalid credentials
    When user is at "login_page"
    Given a "login_email_field" widget
    And a "login_pwd_field" widget
    And a "login_btn_idle" widget
    When user enter "abc@123" in "login_email_field"
    And user enter "12345" in "login_pwd_field"
    When user tap "login_btn_idle"
    Then "Exception: Invalid Credentials" should show


  Scenario: login pass - valid credentials
    When user is at "login_page"
    Given a "login_email_field" widget
    And a "login_pwd_field" widget
    And a "login_btn_idle" widget
    When user enter "root@gmail.com" in "login_email_field"
    And user enter "1q2w3e4r" in "login_pwd_field"
    When user tap "login_btn_idle"
    Then "Home Page" should show