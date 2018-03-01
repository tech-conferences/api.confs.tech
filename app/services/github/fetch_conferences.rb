module Github
  class FetchConferences < ApplicationService
    DEFAULT_URL = 'https://raw.githubusercontent.com/tech-conferences/confs.tech/master/conferences'
    JS_URL      = 'https://raw.githubusercontent.com/tech-conferences/javascript-conferences/master/conferences'

    CONF_TYPES = %w[javascript css php ux ruby ios android general].freeze

    def execute
      (start_year..end_year).map do |year|
        CONF_TYPES.map do |topic|
          response = Faraday.get "#{topic == 'javascript' ? JS_URL : DEFAULT_URL}/#{year}/#{topic}.json"

          if response.success?
            handle_success(JSON.parse(response.body), topic)
          else
            handle_error
          end
        end
      end.flatten.compact
    end

    private

    def handle_success(conferences, topic)
      conferences.map do |details|
        Conference.new(details.merge(topics: [topic]))
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
