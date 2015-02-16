require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Ruby On Rails Tutorial"
    assert_equal full_title("asd"), "asd | Ruby On Rails Tutorial
  end
end