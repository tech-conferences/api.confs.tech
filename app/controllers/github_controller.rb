class GithubController < ApplicationController

  def index
    gh_wrapper = GithubWrapper.new
    result = gh_wrapper.list

    render json: result
  end

  def create
    gh_wrapper = GithubWrapper.new
    head = params[:head]
    title = params[:title]

    result = gh_wrapper.create_pull_request(head, title)

    render json: result
  end

end
