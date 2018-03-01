require 'test_helper'

class GithubControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get github_index_url
    assert_response :success
  end

end
