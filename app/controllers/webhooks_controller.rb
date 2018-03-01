class WebhooksController < ApplicationController
  def sync
    new_conferences = Github::FetchConferences.run

  end
end
