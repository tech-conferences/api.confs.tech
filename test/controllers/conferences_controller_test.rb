require 'test_helper'

class ConferencesControllerTest < ActionDispatch::IntegrationTest
  # test "POST /conferences succeeds" do
  #   post conferences_url, params: conference_params
  #   assert_equal JSON.parse(response.body)
  #   assert_equal response.status, 200
  # end

  # test "POST /conferences fails with bad url" do
  #   post conferences_url, params: conference_params.merge(url: 'bad-url')
  #   assert_equal response.status, 422
  #   assert_equal JSON.parse(response.body)['error'] == 'topic'
  # end

  test "POST /conferences fails with bad topic" do
    post conferences_url, params: conference_params.merge(topic: 'bad-topic')
    assert_equal response.status, 422
    assert_equal JSON.parse(response.body)['error'], 'topic'
  end

  test "POST /conferences fails with bad dates" do
    post conferences_url, params: conference_params.merge(topic: 'bad-topic')
    assert_equal response.status, 422
    assert_equal JSON.parse(response.body)['error'], 'topic'
  end

  test "POST /conferences fails if missing keys" do
    post conferences_url, params: {name: 'Name'}
    assert_equal response.status, 422
    assert_equal JSON.parse(response.body)['error'], 'topic'
  end

  private

  def conference_params
    {
      name: 'Name',
      url: 'nimz.co',
      startDate: '2018-04-01',
      endDate: '2018-04-01',
      city: 'Nice',
      country: 'France',
      topic: 'javascript'
    }
  end
end
