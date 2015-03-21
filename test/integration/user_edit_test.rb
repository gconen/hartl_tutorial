require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test_user)
  end
  
  test "invalid information shouldn't update a user" do
    login_as(@user)
    reference_user = @user.clone 
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                      email: "thisonesvalid@valid.com",
                      password: "password",
                      password_confirmation: "password"
                    }
    assert_template 'users/edit'
    #check to see that @user and reference_user still match aka the database isn't edited
    @user.reload
    assert_equal @user.email, reference_user.email
    assert_equal @user.name, reference_user.name
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "Valid name",
                      email: "Invalid Email",
                      password: "password",
                      password_confirmation: "password"
                    }
    @user.reload
    assert_equal @user.name, reference_user.name
    assert_equal @user.email, reference_user.email
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "Valid name",
                      email: "valid@valid.com",
                      password: "password",
                      password_confirmation: "not the password"
                    }
    @user.reload
    assert_equal @user.name, reference_user.name
    assert_equal @user.email, reference_user.email
    
  end
  
  test "update successfully updates database" do
    login_as(@user)
    name = "New Name"
    email = "new@test.com"
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: name,
                      email: email,
                      password: "",
                      password_confirmation: ""
                    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
    assert_not BCrypt::Password.new(@user.password_digest).is_password?("")
  end
  
  test "friendly forwarding works properly" do
    get edit_user_path(@user)
    login_as(@user)
    assert_redirected_to edit_user_path(@user)
  end
  
end
