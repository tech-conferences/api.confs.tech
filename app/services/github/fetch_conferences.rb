module Github
  class FetchConferences < ApplicationService
    DEFAULT_URL = 'https://raw.githubusercontent.com/tech-conferences/confs.tech/master/conferences'
    JS_URL      = 'https://raw.githubusercontent.com/tech-conferences/javascript-conferences/master/conferences'

    def results
      @results ||= []
    end

    def execute
      (start_year..end_year).map do |year|
        Topic.all.map do |topic|
          begin
            response = Faraday.get "#{topic.name == 'javascript' ? JS_URL : DEFAULT_URL}/#{year}/#{topic.name}.json"
            response.success? ? handle_success(response, topic) : handle_error
          rescue => e
            # TODO: send email to Nima that entry has an invalid key
          end
        end
      end
      results.compact
    end

    private

    def handle_success(response, topic)
      JSON.parse(response.body).map do |details|
        results << Conference.create_or_update(details, topic)
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
