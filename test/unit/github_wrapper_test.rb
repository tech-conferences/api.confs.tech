require 'test_helper'

class GithubWrapperTest < ActiveSupport::TestCase
  setup do
    @gh_wrapper = GithubWrapper.new
  end

  # test "pull_from_repo returns an existing file from the repository" do
  #   path = 'conferences/2018/ruby.json'
  #   file = @gh_wrapper.pull_from_repo(path)
  #   assert_equal "ruby.json", file[:name]
  #   assert_equal "https://api.github.com/repos/#{@gh_wrapper.repository}/contents/conferences/2018/ruby.json?ref=#{@gh_wrapper.base}",
  #    file[:url]
  #   assert_equal "9d1300fec7a5018cfe452fb9ebb8bc84704a62ee", file[:sha]
  # end
end
