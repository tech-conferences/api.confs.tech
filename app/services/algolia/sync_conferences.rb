module Algolia
  class SyncConferences < ApplicationService

    def initialize(conference)
      @conference = conference
    end

    def add
      algolia.add_object(@conference)
    end

    def remove
      algolia.delete_object(@conference.uuid)
    end

    private

    def algolia
      @@algolia ||= Algolia::Index.new(index_name)
    end

    def index_name
      Rails.env.production? ? 'prod_conferences' : 'dev_conferences'
    end
  end
end
