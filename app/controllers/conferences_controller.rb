require 'github_wrapper'

class ConferencesController < ApplicationController
  skip_before_action :authenticate_request
  before_action :validate_topic, only: :create
  before_action :validate_params, only: :create

  def create
    gh_wrapper = ::GithubWrapper.new(conference_params[:topic])
    file = gh_wrapper.pull_from_repo(filepath)
    commit_content = gh_wrapper.update(file[:content], sanatize_conf_params(conference_params))
    commit = gh_wrapper.create_commit(commit_message, file[:path], file[:sha], commit_content, branch_name)
    result = gh_wrapper.create_pull_request(branch_name, commit_message, pr_body)

    render json: result
  end

  private

  def pr_body
   <<~PRBODY
      Hey there, it's ConfsBot! 👋🏼

      Here is a new conference:
      ```json
      #{JSON.pretty_generate(sanatize_conf_params(conference_params))}
      ```
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
    string = "#{params[:name]}-#{params[:url]}-#{params[:startDate]}"
    Digest::SHA2.hexdigest(string)[0..16]
  end

  def year
    return Date.today.year unless conference_params[:startDate]
    conference_params[:startDate].split('-').first
  end

  def filepath
    "conferences/#{year}/#{conference_params[:topic]}.json"
  end

  def sanatize_conf_params(params)
    params.delete :topic
    params[:url] = params[:url].gsub(/\/$/, '')
    params
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
      :cfpEndDate
    ).to_h
  end
end
