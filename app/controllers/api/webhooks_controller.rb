class Api::WebhooksController < ApiController
  def sync
    response = Github::FetchConferences.run
    render json: response
  end
end
