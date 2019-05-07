class GithubWrapper

  attr_accessor(:repository, :base, :client)

  def initialize
    @repository = 'tech-conferences/conference-data'
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

  def pull_or_create_from_repo(path)
    @client.contents(@repository, path: path, query: {ref: @base})
  end

  def update(encoded, content = nil)
    conferences_json = if encoded.present?
      JSON.parse(Base64.decode64(encoded))
    else
      []
    end

    return conferences_json if content.blank?

    conferences_json << content
    ordered_conferences = order_confs(conferences_json)
    JSON.pretty_generate(ordered_conferences)
  end

  def head_sha
    refs = @client.refs(@repository, 'heads')
    master_ref = refs.select{|ref| ref[:ref] == 'refs/heads/master'}[0]
    master_ref[:object][:sha]
  end

  private

  def order_confs(confs)
    begin
      confs.sort_by do |conf|
        Conference.new(Conference.whitelised_attributes(conf)).start_date
      end
    rescue => exception
      confs
    end
  end
end
