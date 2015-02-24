require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
   test "invalid users don't enter database" do
    assert_no_difference 'User.count' do
       get signup_path
       post users_path, user: {name: "  ", email: 'test#test.com', 
                                password: "password",
                                password_confirmation: "password"
                                }
    end
    assert_template 'users/new'
   end
end
