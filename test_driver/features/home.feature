Feature: Home Page Data

  Scenario: Loading of data from login page
    When user is at "login_page"
    Given a "login_email_field" widget
    And a "login_pwd_field" widget
    And a "login_btn_idle" widget
    When user enter "root@gmail.com" in "login_email_field"
    And user enter "1q2w3e4r" in "login_pwd_field"
    When user tap "login_btn_idle"
    Then "Home Page" should show
    Then "model_dismissible" should show on screen