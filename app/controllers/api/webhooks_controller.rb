class Api::WebhooksController < ApiController
  def sync
    response = FetchConferencesService.run
    render json: response
  end
end
