class FetchConferencesService < ApplicationService
  CONFERENCES_URL = 'https://raw.githubusercontent.com/tech-conferences/conference-data/master/conferences'

  def results
    @results ||= []
  end

  def execute
    progress_bar = ProgressBar.new Topic.count
    (start_year..end_year).map do |year|
      Topic.all.map do |topic|
        progress_bar.increment!
        begin
          response = Faraday.get "#{CONFERENCES_URL}/#{year}/#{topic.name}.json"
          response.success? ? handle_success(response, topic) : handle_error
        rescue => exception
          Bugsnag.notify(exception)
        end
      end
    end
    existing_conferences = Conference.where(start_date: (Date.new(start_year, 1, 1)..Date.new(end_year, 12, 31)))
    (existing_conferences - results).map(&:destroy)

    results
  end

  private

  def handle_success(response, topic)
    conferences_data = JSON.parse(response.body)
    conferences_data.map do |details|
      results << Conference.create_or_update(details, topic)
    end
  end

  def handle_error
    # TODO
  end

  def start_year
    Date.current.year
  end

  def end_year
    Date.current.year + 1
  end
end
