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
      @@algolia ||= Algolia::Index.new('conferences')
    end
  end
end
