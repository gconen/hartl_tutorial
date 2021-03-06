require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:test_user)
  end
  
  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    #test the creation of a new reset
    #invalid email
    post password_resets_path, password_reset: {email: "not valid"}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #valid email
    post password_resets_path, password_reset: {email: @user.email}
    assert_not flash.empty?
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_redirected_to root_url
    #test the changing of the password
    user = assigns(:user)
    #wrong email
    get edit_password_reset_path(user.reset_token, email: "something@else.com")
    assert_redirected_to root_url
    #wrong token
    get edit_password_reset_path("not a token", email: @user.email)
    assert_redirected_to root_url
    #user not activated
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: @user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #correct link
    get edit_password_reset_path(user.reset_token, email: @user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden]'
    #invalid password and confirmation
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "password",
                  password_confirmation: "doesntmatch" }
    assert_select 'div#error_explanation'
    #blank password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "    ",
                  password_confirmation:  "    " }
    assert_not flash.empty?
    assert_template "password_resets/edit"
    #changes password
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password:              "differentpassword",
                  password_confirmation:  "differentpassword" }
    assert_not flash.empty?
    assert is_logged_in?
    assert_redirected_to user
    assert_not_equal @user.password_digest, @user.reload.password_digest
  end

  
end
