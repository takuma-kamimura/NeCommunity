require "test_helper"

class TopsControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get tops_top_url
    assert_response :success
  end
end
