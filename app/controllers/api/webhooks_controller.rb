class Api::WebhooksController < ApiController
  def sync
    topics = Topic.where(name: params[:topic]) if params[:topic].present?
    if topics.any?
      response = Github::FetchConferences.run topics
    else
      response = Github::FetchConferences.run
    end
    render json: response
  end
end
