module Github
  class FetchConferences < ApplicationService
    DEFAULT_URL = 'https://raw.githubusercontent.com/tech-conferences/confs.tech/master/conferences'
    JS_URL      = 'https://raw.githubusercontent.com/tech-conferences/javascript-conferences/master/conferences'

    CONF_TOPICS = %w[javascript css php ux ruby ios android general].freeze

    def results
      @results ||= {}
    end

    def execute
      (start_year..end_year).map do |year|
        CONF_TOPICS.map do |topic|
          begin
            response = Faraday.get "#{topic == 'javascript' ? JS_URL : DEFAULT_URL}/#{year}/#{topic}.json"
            response.success? ? handle_success(response, topic) : handle_error
          rescue => e
            # TODO: send email to Nima that entry has an invalid key
          end
        end
      end
      results.values
    end

    private

    def handle_success(response, topic)
      JSON.parse(response.body).map do |details|
        id = Digest::SHA1.base64digest "#{URI.parse(details['url']).host}-#{details['startDate']}"
        if results[id]
          results[id].topics |= [topic]
        else
          results[id] = Conference.new(details.merge(id: id, topics: [topic]))
        end
      end
    end

    def handle_error
      # TODO
    end

    def start_year
      Date.current.year - 1
    end

    def end_year
      Date.current.year + 1
    end
  end
end
