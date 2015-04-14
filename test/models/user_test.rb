require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
     @user = User.new(name:"Tom Est", email:"test@test.org", password: "asdfg1", password_confirmation: "asdfg1")
  end
   
  test "initial user should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = 'a'*250 + "@test.org"
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = 'a' * 100 
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test 'authenticated? should fail gracefully if no digest present' do
    assert_not @user.authenticated?('asdf', :remember)
  end
  
  test "associated microposts should be destoyed with user" do
    @user.save
    @user.microposts.create!(content: "Not Relevant")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "following and unfollowing users" do
    person_1 = users(:test_user)
    person_2 = users(:other_user)
    assert_not person_1.following?(person_2)
    person_1.follow(person_2)
    assert person_1.following?(person_2)
    assert person_2.followers.include?(person_1)
    person_1.unfollow(person_2)
    assert_not person_1.following?(person_2)
  end
  
  test "feed should have the right posts" do
    alice = users(:alice)
    bob = users(:bob)
    doug = users(:doug)
    bob.microposts.each do |post_following|
      assert alice.feed.include?(post_following)
    end
    alice.microposts.each do |post_self|
      assert alice.feed.include?(post_self)
    end
    doug.microposts.each do |post_not_following|
      assert_not alice.feed.include?(post_not_following)
    end
  end
    
  

end
