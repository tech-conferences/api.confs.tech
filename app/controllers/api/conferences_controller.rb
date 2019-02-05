class Api::ConferencesController < ApiController
  skip_before_action :authenticate_request
  before_action :validate_topic, only: :create
  before_action :validate_params, only: :create

  def create
    gh_wrapper = ::GithubWrapper.new
    file = gh_wrapper.pull_from_repo(filepath)
    commit_content = gh_wrapper.update(file[:content], sanatize_conf_params(conference_params))
    commit = gh_wrapper.create_commit(commit_message, file[:path], file[:sha], commit_content, branch_name)
    result = gh_wrapper.create_pull_request(branch_name, commit_message, pr_body)

    render json: result
  end

  private

  def pr_body
    sanatize_params = sanatize_conf_params(conference_params)

    <<~PRBODY
      Hey there, it's ConfsBot! 👋🏼

      Here is a new conference:
      [#{sanatize_params[:url]}](#{sanatize_params[:url]})
      #{sanatize_params[:cfpUrl].present? ? "[#{sanatize_params[:cfpUrl]}](#{sanatize_params[:cfpUrl]})" : ''}

      ```json
      // #{@topic}

      #{JSON.pretty_generate(sanatize_params)}
      ```
      #{params[:comment] ? '--' : ''}
      #{params[:comment]}
    PRBODY
  end

  def validate_topic
    if Topic.where(name: conference_params[:topic]).length === 0
      render json: { error: 'topic' }, status: 422
    end
  end

  def validate_params
    conf = Conference.new(conference_params.except(:topic))

    if !conf.valid?
      render json: { error: conf.errors }, status: 422
    end
  end

  def commit_message
    "Add #{params[:name]} conference"
  end

  def branch_name
    @branch_name ||= (0...19).map { (65 + rand(26)).chr }.join.downcase
  end

  def year
    return Date.today.year unless conference_params[:startDate]
    conference_params[:startDate].split('-').first
  end

  def filepath
    "conferences/#{year}/#{conference_params[:topic]}.json"
  end

  def sanatize_conf_params(params)
    @topic = params.delete :topic
    params.delete :cfpUrl if params[:cfpUrl].blank?
    params.delete :cfpEndDate if params[:cfpEndDate].blank?
    params.delete :twitter if params[:twitter].blank?
    params[:name] = sanatize_name params[:name]
    params[:country] = sanatize_country_name params[:country]

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

  def conference_params
    params.permit(
      :name,
      :url,
      :startDate,
      :endDate,
      :city,
      :country,
      :twitter,
      :topic,
      :cfpUrl,
      :cfpEndDate,
    ).to_h
  end
end
