module Github
  class FetchConferences < ApplicationService
    DEFAULT_URL = 'https://raw.githubusercontent.com/tech-conferences/confs.tech/master/conferences'
    JS_URL      = 'https://raw.githubusercontent.com/tech-conferences/javascript-conferences/master/conferences'

    CONF_TYPES = %w[javascript css php ux ruby ios android general].freeze

    def execute
      (start_year..end_year).map do |year|
        CONF_TYPES.map do |type|
          response = Faraday.get "#{type == 'javascript' ? JS_URL : DEFAULT_URL}/#{year}/#{type}.json"

          if response.success?
            handle_success(JSON.parse(response.body), type)
          else
            handle_error
          end
        end
      end.flatten.uniq
    end

    private

    def handle_success(conferences, type)
      conferences.map do |details|
        Conference.new(details)
      end
    end

    def handle_error
      # TODO
    end

    def start_year
      Date.current.year
    end

    def end_year
      start_year + 1
    end
  end
end
