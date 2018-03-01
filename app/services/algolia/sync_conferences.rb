module Algolia
  class SyncConferences < ApplicationService

    APPLICATION_ID = 'I2MPXQ1WUO' #'8MN5N7L4M3'
    API_KEY = '66dfa32ebbd818d53d5cbdf45f499ce2' #'fc9ac0af9e5feec3531031b37d239cbc'
    ALGOLIA_INDEX_NAME = 'conferences'

    def initialize(conferences = nil)
      @conferences = conferences || Github::FetchConferences.run
    end

    def execute
      angolia.add_objects(@conferences)
    end

    private

    def angolia
      @@angolia ||= begin
        Algolia.init(application_id: APPLICATION_ID, api_key: API_KEY)
        Algolia::Index.new(ALGOLIA_INDEX_NAME)
      end
    end
  end
end
