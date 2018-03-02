class GithubWrapper

  attr_accessor(:repository, :base, :client)

  def initialize(base = 'master')
    @repository = Rails.configuration.gh_repo
    @base = base
    @client = Octokit::Client.new(:access_token => Rails.configuration.gh_token)
  end

  def create_pull_request(head, title)
    pull_request = @client.create_pull_request(@repository, @base, head, title)
    return { status: @client.last_response.status,
             data: pull_request }
  end

  def create_commit(message, path, sha, content, branch)
    create_branch(branch)

    commit = @client.update_contents(
      @repository, 
      path, 
      message,
      sha, 
      content,
      :branch => branch)
    commit
  end

  def create_branch(branch)
    @client.create_ref(@repository, "heads/#{branch}", "0b4af9d05c4a1b6d43afd6e14054b61f18d4e8a1")
  end

  def pull_from_repo(path)
    file = @client.contents(@repository, path: path, query: {ref: @base})
    file
  end

  def update(encoded, content)
    json = Base64.decode64(encoded)
    hash = JSON.parse(json)
    #hash.merge!content
    hash << content
    JSON.pretty_generate(hash)
  end
    
  def list(state='closed')
    pull_requests = @client.pull_requests(@repository, :state => state)
    return { status: @client.last_response.status,
             data: pull_requests }
  end

end
