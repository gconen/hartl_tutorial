require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:test_user)
    @other_user = users(:other_user)
    @admin = users(:admin_user)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "edit should not be available if not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "update should not be available if not logged in" do
    get :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "index should, for some reason, not be available if not logged in" do
    get :index
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "edit should not be available to the wrong user" do
    login_as(@other_user)
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "update should not be available to the wrong user" do
    login_as(@other_user)
    get :update, id: @user
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "non-admins should not be able to delete users" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
    login_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
  
  test "admins delete users" do
    login_as(@admin)
    assert_difference 'User.count', -1 do
      delete :destroy, id: @user
    end
    assert_redirected_to users_url
  end
  
  test "should redirect following when not logged in" do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end


end
