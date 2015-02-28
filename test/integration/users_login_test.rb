require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
   test "flash displays correctly" do
     get login_path
     assert_template 'sessions/new'
     post login_path session: {email: "test@test.com", password: "notthepassword"}
     assert_template 'sessions/new'
     assert_not flash.empty?
     get root_path
     assert flash.empty?
   end
end
