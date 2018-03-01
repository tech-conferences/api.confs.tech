class GithubWrapper

  attr_writer(:repository, :base, :client)

  def initialize(base = 'master')
    @repository = Rails.configuration.gh_repo
    @base = base
    @client = Octokit::Client.new(:access_token => Rails.configuration.gh_token)
  end

  def create_pull_request(head, title)
    pull_request = @client.create_pull_request(@repository, @base, head, title)
    return { status: response.status,
              data: pull_request }
  end

  def list(state='closed')
    pull_requests = @client.pull_requests(@repository, :state => state)
    return { status: @client.last_response.status,
              data: pull_requests }
  end

end
