class GithubWrapper

  attr_accessor(:repository, :base, :client)

  def initialize(topic = 'javascript')
    @repository = get_repository(topic)
    @base = 'master'
    @client = Octokit::Client.new(access_token: Rails.application.secrets.github_token)
  end

  def create_pull_request(head, title, body='')
    {
      status: @client.last_response.status,
      data: @client.create_pull_request(@repository, @base, head, title, body)
    }
  end

  def create_commit(message, path, sha, content, branch)
    create_branch(branch)

    @client.update_contents(
      @repository,
      path,
      message,
      sha,
      content,
      branch: branch
    )
  end

  def create_branch(branch)
    @client.create_ref(
      @repository,
      "heads/#{branch}", head_sha
    )
  end

  def pull_from_repo(path)
    @client.contents(@repository, path: path, query: {ref: @base})
  end

  def update(encoded, content)
    json = Base64.decode64(encoded)
    hash = JSON.parse(json)
    hash << content
    JSON.pretty_generate(hash)
  end

  def head_sha
    refs = @client.refs(@repository, 'heads')
    master_ref = refs.select{|ref| ref[:ref] == 'refs/heads/master'}[0]
    master_ref[:object][:sha]
  end

  private

  def get_repository(topic)
    if topic === 'javascript'
      'tech-conferences/javascript-conferences'
    else
      'tech-conferences/confs.tech'
    end
  end
end
