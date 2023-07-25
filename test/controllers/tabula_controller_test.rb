require "test_helper"

class TabulaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tabula_index_url
    assert_response :success
  end
end
