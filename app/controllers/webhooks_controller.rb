class WebhooksController < ApplicationController
  def sync
    # TODO: move to BG job
    response = Algolia::SyncConferences.run
    render json: { success: response["objectIDs"].present? }
  end
end
