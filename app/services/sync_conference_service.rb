class SyncConferenceService < ApplicationService
  def initialize(conference)
    @conference = conference
  end

  def add
    index.save_object(@conference.as_json)
  end

  def remove
    index.delete_object(@conference.uuid)
  end

  private

  def index
    client = Algolia::Search::Client.create(ENV['ALGOLIA_APPLICATION_ID'], ENV['ALGOLIA_API_KEY'])

    @index = client.init_index(index_name)
  end

  def index_name
    Rails.env.production? ? 'prod_conferences' : 'dev_conferences'
  end
end
