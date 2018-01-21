Feature: Symfony 4 to explore BDDfire


Scenario: View Hello World home page
  Given I am on "http://nginx:20080"
  Then I should see "Hello World"
