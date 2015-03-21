require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:test_user)
    @other_user = users(:other_user)
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
  
end
