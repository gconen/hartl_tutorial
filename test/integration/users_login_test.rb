require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
   def setup
       @user = users(:test_user)
   end
   
   test "flash displays correctly" do
     get login_path
     assert_template 'sessions/new'
     post login_path session: {email: "test@test.com", password: "notthepassword"}
     assert_template 'sessions/new'
     assert_not flash.empty?
     get root_path
     assert flash.empty?
   end

   test "valid information logs in and logs out" do
       get login_path
       post login_path session: {email: @user.email, password: 'password'}
       assert_redirected_to @user
       follow_redirect!
       assert_template 'users/show'
       assert is_logged_in?
       assert_select 'a[href=?]', login_path, count:0
       assert_select 'a[href=?]', logout_path
       assert_select 'a[href=?]', user_path(@user)
       delete logout_path
       assert_not is_logged_in?
       assert_redirected_to root_path
       follow_redirect!
       assert_select 'a[href=?]', login_path
       assert_select 'a[href=?]', logout_path, count: 0
       assert_select 'a[href=?]', user_path(@user), count: 0
   end
   
    test "gracefully handles logout twice" do
        post login_path session: {email: @user.email, password: 'password'}
        follow_redirect!
        delete logout_path
        delete logout_path
    end
 
end
