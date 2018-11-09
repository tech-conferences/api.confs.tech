module Github
  class FetchConferences < ApplicationService
    CONFERENCES_URL = 'https://raw.githubusercontent.com/tech-conferences/conference-data/master/conferences'

    def results
      @results ||= []
    end

    def execute(topics = Topic.all)
      (start_year..end_year).map do |year|
        topics.map do |topic|
          begin
            response = Faraday.get "#{CONFERENCES_URL}/#{year}/#{topic.name}.json"
            response.success? ? handle_success(response, topic) : handle_error(response, topic)
          rescue => exception
            Bugsnag.notify(exception)
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

    def handle_error(response, topic)
      Bugsnag.notify(exception)
    end

    def start_year
      Date.current.year - 1
    end

    def end_year
      Date.current.year + 1
    end
  end
end
