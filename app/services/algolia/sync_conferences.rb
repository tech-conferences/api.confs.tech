module Algolia
  class SyncConferences < ApplicationService

    APPLICATION_ID = '8MN5N7L4M3'
    API_KEY = 'fc9ac0af9e5feec3531031b37d239cbc'
    ALGOLIA_INDEX_NAME = 'conferences'

    def initialize(conferences)
      @conferences = conferences
    end

    def execute
      angolia.add_objects(@conferences)
    end

    private

    def angolia
      @angolia ||= begin
        Algolia.init(application_id: APPLICATION_ID, api_key: API_KEY)
        Algolia::Index.new(ALGOLIA_INDEX_NAME)
      end
    end
  end
end
