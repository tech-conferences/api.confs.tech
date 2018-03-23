require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase
  test "set uuid" do
    conference = Conference.new(url: 'lala')
    conference.valid?
    assert conference.uuid.present?
  end

  test "Url being formatted if needed" do
    conference = Conference.new(url: 'lala')
    conference.save(validate: false)
    assert_equal conference.url, 'http://lala'
  end
end
