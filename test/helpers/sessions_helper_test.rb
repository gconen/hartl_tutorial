require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
    def setup
        @user = users(:test_user)
        remember(@user)
    end
    
    test 'remember creates cookies' do
        remember(@user)
        assert_not_nil cookies['remember_token']
    end
    
    test 'current_user returns the right user when session is nil' do
        assert_equal @user, current_user
        #assert logged_in?
    end
    
    test "current_user returns nil when the token and digest don't match" do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        assert_nil current_user
    end
    
    
end
    