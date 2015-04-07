require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:test_user)
    @micropost = @user.microposts.build(content:"Sample Content")
  end
  
  #test the validations
  
  test "the post created by setup should be valid" do
    assert @micropost.valid?
  end
  
  test "micropost without user_id should be invalid" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should not be blank" do
    @micropost.content = "     "
    assert_not @micropost.valid?
  end
  
  test "140 character limit" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "first post in the database should be the most recent" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
  
end
