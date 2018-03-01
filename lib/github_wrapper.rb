class GithubWrapper

  attr_writer(:repository, :base, :client)

  filename = "https://raw.githubusercontent.com/nimzco/confs.tech/master/conferences/2018/ruby.json".freeze

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

  def create_commit
    path = 'conferences/2018/ruby.json'
    branch = 'add-ruby-conference-2018'
    file = @client.contents(@repository, path: path, query: {ref: 'master'})
    enc = file[:content]
    plain = JSON.parse(Base64.decode64(enc)) << hash_to_submit
    commit = @client.update_contents(
      @repository, 
      path, 
      "Adding new Ruby conference in 2018", 
      file[:sha], 
      JSON.pretty_generate(plain), 
      :branch => branch)
    commit
  end

  def list(state='closed')
    pull_requests = @client.pull_requests(@repository, :state => state)
    return { status: @client.last_response.status,
             data: pull_requests }
  end

  private

  def hash_to_submit
    h = {
      "name": "Ruby on Ice",
      "url": "https://rubyonice.com/",
      "startDate": "2018-01-26",
      "endDate": "2018-01-28",
      "city": "Tegernsee",
      "country": "Germany",
      "twitter": "@rubyoniceconf"
    }
    h
  end

end
