require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
   def setup
       ActionMailer::Base.deliveries.clear
   end
   
   test "invalid signup" do
        assert_no_difference 'User.count' do
            get signup_path
            post users_path, user: {name: "  ", email: 'test#test.com', 
                                password: "password",
                                password_confirmation: "password"
                                }
        end
        assert_template 'users/new'
        assert_select "div#error_explanation"
        assert_select "div.field_with_errors"
   end
   
   test "valid signup with activation" do
        get signup_path
        assert_difference 'User.count', 1 do
            post users_path, user: {name: "name", email: 'emailmustbeunique@test.com', 
                                password: "password",
                                password_confirmation: "password"
                                }
        end
        assert_equal ActionMailer::Base.deliveries.size, 1
        user = assigns(:user)
        assert_not user.activated?
        #try to login before activation; but shouldn't this go in users_login_test?
        login_as(user)
        assert_not is_logged_in?
        #valid token, wrong email
        get edit_account_activation_path(user.activation_token, email: "wrong@wrong.com")
        assert_not is_logged_in?
        #invalid token, right email
        get edit_account_activation_path("Not a token", email: user.email)
        assert_not is_logged_in?
        #finally activated
        get edit_account_activation_path(user.activation_token, email: user.email)
        user = user.reload
        assert user.activated?
        follow_redirect!
        assert_template 'users/show'
        assert is_logged_in?
   end
   
end
