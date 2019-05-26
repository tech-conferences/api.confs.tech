require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase
  test "set uuid" do
    conference = Conference.new(conference_params(url: 'lala'))
    conference.valid?
    assert conference.uuid.present?
  end

  test "Url being formatted if needed" do
    conference = Conference.new(conference_params(url: 'lala.com/'))
    conference.send :fix_url
    assert_equal 'http://lala.com', conference.url
  end

  test "cfpUrl being formatted if needed" do
    conference = Conference.new(conference_params(url: 'lala.com/', cfpUrl: 'lala.com/'))
    conference.send :fix_url
    assert_equal 'http://lala.com', conference.cfpUrl
  end

  test "add javascript topic if topic is typescript" do
    conference = Conference.new(
      conference_params(
        url: 'lala.com/', cfpUrl: 'lala.com/', topics: [Topic.find_by_name('typescript')]
      )
    )
    conference.save
    assert_equal 2, conference.topics.length
    assert_includes conference.topics, Topic.find_by_name('javascript')

    # Still has 2 topics even after multiple save
    conference.save
    assert_equal 2, conference.topics.length
  end

  private

  def conference_params(extra_params = {})
    {
      name: 'Name',
      url: 'nimz.co',
      startDate: '2018-04-01',
      endDate: '2018-04-01',
      city: 'Nice',
      country: 'France',
      topics: [Topic.find_by_name('javascript')]
    }.merge(extra_params)
  end
end

