class WebhooksController < ApplicationController
  def sync
    response = Github::FetchConferences.run
    render json: response
  end
end
