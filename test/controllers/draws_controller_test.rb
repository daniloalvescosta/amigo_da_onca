require "test_helper"

class DrawsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get draws_index_url
    assert_response :success
  end

  test "should get create" do
    get draws_create_url
    assert_response :success
  end
end
