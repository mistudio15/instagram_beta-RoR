# require 'selenium-webdriver'
# require 'json'

# require "application_system_test_case"

# class LikesTest < ApplicationSystemTestCase

#     def setup
#       @driver = Selenium::WebDriver.for :firefox
#       # @vars = {}
#     end

#     test 'set likes' do
#       @driver.get('http://localhost:3000/en/signin')
#       @driver.manage.resize_to(1550, 838)
#       @driver.find_element(:id, 'email').click
#       @driver.find_element(:id, 'email').send_keys('mikhail.m@gmail.com')
#       @driver.find_element(:id, 'password').click
#       @driver.find_element(:id, 'password').send_keys('1')
#       @driver.find_element(:name, 'commit').click
#       @driver.find_element(:css, '.col-4:nth-child(2) img').click
#       @driver.find_element(:name, 'commit').click
#       @driver.find_element(:name, 'commit').click
#       @driver.find_element(:id, 'comment_body').click
#       @driver.find_element(:id, 'comment_body').send_keys('Неплохое фото!')
#       @driver.find_element(:id, 'input_comment').click
#       @driver.find_element(:css, '.w-50').click
#     end

#     def teardown  
#     end

# end

