require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
   def setup
       @user = users('test_user')
       remember(@user)
   end
   
   test "cookies should be created" do
       assert_not_nil cookies["remember_token"]
   end
   
   test "current user finds the correct user from cookies" do
       assert_equal @user, current_user
       assert is_logged_in?
   end
   
   test "current user returns nil when the token doesn't match the digest" do
       @user.update_attribute(:remember_digest, User.digest(User.new_token))
       assert_nil current_user
       assert_not is_logged_in?
   end
   
end