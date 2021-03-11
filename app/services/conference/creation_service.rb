class Conference::CreationService < ApplicationService
  class << self
    delegate :run!, to: :new
  end

  def run!(params:)
    @params = params
    sanatize_params(@params)

    @gh_wrapper ||= ::GithubWrapper.new

    commit_content = @gh_wrapper.update(file[:content], @params)
    @gh_wrapper.create_commit(commit_message, filepath, file[:sha], commit_content, branch_name)

    @gh_wrapper.create_pull_request(branch_name, commit_message, pr_body)
  end

  private

  def sanatize_params(params)
    @topic = params.delete :topic

    params.delete(:cfpUrl) if params[:cfpUrl].blank?
    params.delete(:cfpEndDate) if params[:cfpEndDate].blank?
    params.delete(:cocUrl) if params[:cocUrl].blank?
    params.delete(:offersSignLanguageOrCC) if params[:offersSignLanguageOrCC] == false
    params.delete(:twitter) if params[:twitter].blank? || params[:twitter] == '@'

    params[:name] = sanatize_name(params[:name])
    params[:country] = sanatize_country_name(params[:country]) if params[:country].present?

    if params[:country].downcase == 'online' || params[:city].downcase == 'online'
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

  def sanatize_country_name(country_name)
    case country_name.downcase
    when 'the netherlands', 'nl'
      return 'Netherlands'
    when 'u.s.', 'us', 'usa', 'u.s.a', 'united states', 'united states of america'
      return 'U.S.A.'
    when 'uk', 'uk.', 'u.k', 'uk', 'united kingdom', 'england'
      return 'U.K.'
    end

    country_name
  end

  def file
    @gh_wrapper.pull_or_create_from_repo(filepath)
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

      ```json
      // #{@topic}

      #{JSON.pretty_generate(@params)}
      ```
    PRBODY

    @pr_body.strip
  end

  def commit_message
    "Add #{@params[:name]}"
  end

  # Random name to prevent branch name collision
  def branch_name
    @branch_name ||= (0...19).map { (65 + rand(26)).chr }.join.downcase
  end

  def year
    return Time.zone.today.year unless @params[:startDate]

    @params[:startDate].split('-').first
  end

  def filepath
    "conferences/#{year}/#{@topic}.json"
  end

  def twitter_url
    return nil if @params[:twitter].blank?

    "Twitter: <a href=\"https://twitter.com/#{@params[:twitter]}\" target=\"_blank\">https://twitter.com/#{@params[:twitter]}</a>"
  end

  def cfp_url
    return nil if @params[:cfpUrl].blank?

    "CFP: <a href=\"#{@params[:cfpUrl]}\" target=\"_blank\">#{@params[:cfpUrl]}</a>"
  end
end
