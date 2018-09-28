require 'test_helper'

class ConferencesControllerTest < ActionDispatch::IntegrationTest
  # test "POST /api/conferences succeeds" do
  #   post api_conferences_path, params: conference_params
  #   assert_equal response.status, 200
  #   assert_equal JSON.parse(response.body)
  # end

  # test "POST /api/conferences fails with bad url" do
  #   post api_conferences_path, params: conference_params.merge(url: 'bad-url')
  #   assert_equal response.status, 422
  #   assert_equal JSON.parse(response.body)['error'] == 'topic'
  # end

  test "POST /api/conferences fails with bad topic" do
    post api_conferences_path, params: conference_params.merge(topic: 'bad-topic')
    assert_equal response.status, 422
    assert_equal JSON.parse(response.body)['error'], 'topic'
  end

  test "POST /api/conferences fails with bad dates" do
    post api_conferences_path, params: conference_params.merge(topic: 'bad-topic')
    assert_equal response.status, 422
    assert_equal JSON.parse(response.body)['error'], 'topic'
  end

  test "POST /api/conferences fails if missing keys" do
    post api_conferences_path, params: {name: 'Name'}
    assert_equal response.status, 422
    assert_equal JSON.parse(response.body)['error'], 'topic'
  end

  test "#sanatize_conf_params removes year name from conf" do
    conference_controller = Api::ConferencesController.new
    params = conference_params.merge({name: 'Conf 2018'})
    conference_controller.stubs(:conference_params).returns(params)
    sanatized_params = conference_controller.send :sanatize_conf_params, params
    assert_equal sanatized_params[:name], 'Conf'
  end

  test "#sanatize_conf_params sanatizes country for USA" do
  conference_controller = Api::ConferencesController.new
  params = conference_params.merge({country: 'USA'})
  conference_controller.stubs(:conference_params).returns(params)
  sanatized_params = conference_controller.send :sanatize_conf_params, params
  assert_equal sanatized_params[:country], 'U.S.A.'
end

  test "#sanatize_conf_params sanatizes country for UK" do
    conference_controller = Api::ConferencesController.new
    params = conference_params.merge({country: 'UK'})
    conference_controller.stubs(:conference_params).returns(params)
    sanatized_params = conference_controller.send :sanatize_conf_params, params
    assert_equal sanatized_params[:country], 'U.K.'
  end

  test "#sanatize_conf_params doesn't sanatizes country if correct" do
    conference_controller = Api::ConferencesController.new
    params = conference_params.merge({country: 'U.S.A.'})
    conference_controller.stubs(:conference_params).returns(params)
    sanatized_params = conference_controller.send :sanatize_conf_params, params
    assert_equal sanatized_params[:country], 'U.S.A.'
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
