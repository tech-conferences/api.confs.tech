class Conference::CreationService < ApplicationService
  class << self
    delegate :run!, to: :new
  end

  def run!(params:)
    @params = params
    sanatize_params(@params)

    @gh_wrapper ||= ::GithubWrapper.new

    @gh_wrapper.create_branch(branch_name)

    @topics.map do |topic|
      commit_content = @gh_wrapper.update(file(topic)[:content], @params)
      @gh_wrapper.create_commit(commit_message(topic), filepath(topic), file(topic)[:sha], commit_content, branch_name)
    end

    @gh_wrapper.create_pull_request(branch_name, pr_message, pr_body)
  end

  private

  def sanatize_params(params)
    @topics = params.delete :topics
    @github = params.delete :github
    @mastodon = params.delete :mastodon

    params.delete(:cfpUrl) if params[:cfpUrl].blank?
    params.delete(:cfpEndDate) if params[:cfpEndDate].blank?
    params.delete(:cocUrl) if params[:cocUrl].blank?
    params.delete(:offersSignLanguageOrCC) if params[:offersSignLanguageOrCC] == false
    params.delete(:twitter) if params[:twitter].blank? || params[:twitter] == '@'

    params[:name] = sanatize_name(params[:name])
    params[:country] = CountrySanatizerService.run!(params[:country]) if params[:country].present?
    params[:city] = CitySanatizerService.run!(params[:city], params[:country]) if params[:city].present?

    if params[:country] == 'online' || params[:city] == 'online'
      params.delete(:country)
      params.delete(:city)
      params[:online] = true
    end

    if params[:online] == true && params[:city].blank? && params[:country].blank?
      params.delete(:country)
      params.delete(:city)
    end

    params[:url] = URLHelper.fix_url(params[:url].gsub(/\/$/, ''))
    params[:cfpUrl] = URLHelper.fix_url(params[:cfpUrl].gsub(/\/$/, '')) if params[:cfpUrl].present?

    params
  end

  def sanatize_name(name)
    name.gsub(year, '').strip
  end

  def file(topic)
    @gh_wrapper.pull_or_create_from_repo(filepath(topic))
  rescue Exception => e
    {
      content: nil,
      sha: nil
    }
  end

  def pr_body
    @pr_body ||= <<~PRBODY
      ## Conference information

      Website: <a href="#{@params[:url]}" target="_blank">#{@params[:url]}</a>
      #{cfp_url}
      #{twitter_url}
      #{github_url}
      #{mastodon_url}

      ```json
      // #{@topics.join(', ')}

      #{JSON.pretty_generate(@params)}
      ```
    PRBODY

    @pr_body.strip
  end

  def commit_message(topic)
    "Add #{@params[:name]} for #{topic}"
  end

  def pr_message
    "Add #{@params[:name]} for #{@topics.join(', ')}"
  end

  # Random name to prevent branch name collision
  def branch_name
    @branch_name ||= (0...19).map { (65 + rand(26)).chr }.join.downcase
  end

  def year
    return Time.zone.today.year unless @params[:startDate]

    @params[:startDate].split('-').first
  end

  def filepath(topic)
    "conferences/#{year}/#{topic}.json"
  end

  def twitter_url
    return nil if @params[:twitter].blank?

    "Twitter: <a href=\"https://twitter.com/#{@params[:twitter]}\" target=\"_blank\">https://twitter.com/#{@params[:twitter]}</a>"
  end

  def github_url
    return nil if @github.blank?

    "Github: @#{@github}"
  end

  def cfp_url
    return nil if @params[:cfpUrl].blank?

    "CFP: <a href=\"#{@params[:cfpUrl]}\" target=\"_blank\">#{@params[:cfpUrl]}</a>"
  end

  def mastodon_url
    return nil if @mastodon.blank?
    _, username, instance = @mastodon.split('@')
    "Mastodon: <a href=\"https://#{instance}/@#{username}\" target=\"_blank\">https://#{instance}/@#{username}</a>"
  end
end
