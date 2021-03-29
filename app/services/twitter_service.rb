class TwitterService < ApplicationService
  def initialize; end

  def tweet(conference)
    return unless Rails.env.production?
    return if conference.tweeted_at.present?
    return if conference.start_date.nil? || (conference.start_date < Time.zone.today)

    client.update(tweet_message(conference))

    conference.tweeted_at = DateTime.now
    conference.save
  end

  def tweet_message(conference)
    tweet = <<~PRBODY
      #{conference.name} is happening on #{conference.start_date.strftime('%B, %-d')}.
      #{conference.location_to_s}
      — #{conference.url}
      #tech #conference #{topics(conference).map { |topic| "##{topic.name}" }.join(' ')}

      #{cfp(conference)}
    PRBODY

    tweet.strip
  end

  private

  def client
    @client ||= ::Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def topics(conference)
    conference.topics.reject { |topic| topic.name == 'general' }
  end

  def cfp(conference)
    return nil if conference.cfpUrl.blank? || conference.cfp_end_date.blank?

    "Submit your proposal for a talk at #{conference.cfpUrl} before #{conference.cfp_end_date.strftime('%B, %-d')}."
  end
end
