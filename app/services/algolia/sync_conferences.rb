module Algolia
  class SyncConferences < ApplicationService

    def initialize(conferences = nil)
      @conferences = conferences || Github::FetchConferences.run
    end

    def execute
      algolia.add_objects(@conferences)
    end

    private

    def algolia
      @@algolia ||= Algolia::Index.new(index_name)
    end

    def index_name
      Rails.env.production ? 'prod_conferences' : 'dev_conferences'
    end
  end
end
