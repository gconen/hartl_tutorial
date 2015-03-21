require 'test_helper'

class UserIndexTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
    @admin = users(:admin_user)
  end
  
  test "index including pagination" do
    login_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), method: :delete, text: "delete"
      end
    end
  end
  
  test "admins delete users" do
    login_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_redirected_to users_url
  end
  
  test "non-admins don't get delete links" do
    login_as(@user)
    assert_select 'a', text: 'delete', count:0
  end
  
end
