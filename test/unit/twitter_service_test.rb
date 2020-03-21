require 'test_helper'

class GithubWrapperTest < ActiveSupport::TestCase
  setup do
    @twitter_service = TwitterService.new
    @conference_params = {
      name: 'Conference',
      url: 'https://web.dev',
      city: 'Nice',
      country: 'France',
      startDate: '2018-01-01',
      endDate: '2018-01-01'
    }
  end

  test "Conference with topics" do
    conference = Conference.new @conference_params
    conference.send :update_start_end_dates
    conference.topics << Topic.new(name: 'ux')
    tweet_message = @twitter_service.send :tweet_message, conference
    expected_message = <<~PRBODY
    Conference is happening on January, 1 in Nice, France
    => https://web.dev
    #tech #conference #ux
    PRBODY
    assert_equal expected_message.strip, tweet_message
  end

  test "Conference with general topic" do
    conference = Conference.new @conference_params
    conference.send :update_start_end_dates
    conference.topics << Topic.new(name: 'general')
    tweet_message = @twitter_service.send :tweet_message, conference
    expected_message = <<~PRBODY
    Conference is happening on January, 1 in Nice, France
    => https://web.dev
    #tech #conference
    PRBODY
    assert_equal expected_message.strip, tweet_message
  end

  test "Conference with CFP" do
    conference = Conference.new @conference_params.merge(cfpUrl: 'cfp.web.dev', cfpEndDate: '2019-01-01')
    conference.send :update_start_end_dates
    tweet_message = @twitter_service.send :tweet_message, conference
    expected_message = <<~PRBODY
    Conference is happening on January, 1 in Nice, France
    => https://web.dev
    Submit your proposal for a talk at cfp.web.dev before January, 1.
    #tech #conference
    PRBODY
    assert_equal expected_message.strip, tweet_message
  end

  test "Conference with twitter" do
    conference = Conference.new @conference_params.merge(twitter: '@twitter')
    conference.send :update_start_end_dates
    tweet_message = @twitter_service.send :tweet_message, conference
    expected_message = <<~PRBODY
    Conference is happening on January, 1 in Nice, France
    => https://web.dev
    #tech #conference
    PRBODY
    assert_equal expected_message.strip, tweet_message
  end
end
