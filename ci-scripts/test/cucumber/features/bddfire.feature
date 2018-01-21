Feature: Symfony 4 to explore BDDfire


Scenario: View Hello World home page
  Given I am on "http://nginx"
  Then I should see "Hello World"

Scenario: Insert 1000 Products
  Given I am on "http://nginx/insert/1000"
  Then I should see "1000 inserted"