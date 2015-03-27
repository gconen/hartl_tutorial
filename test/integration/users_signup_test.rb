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
   
   test "valid users enter database" do
        assert_difference 'User.count', 1 do
            get signup_path
            post_via_redirect users_path, user: {name: "name", email: 'emailmustbeunique@test.com', 
                                password: "password",
                                password_confirmation: "password"
                                }
        end
        assert_template 'users/show'
        assert is_logged_in?
   end
   
end
