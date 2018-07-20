module Twitter
  class TwitterService < ApplicationService
    def initialize
      @client = ::Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.secrets.twitter_consumer_key
        config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret_key
        config.access_token        = Rails.application.secrets.twitter_access_token
        config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
      end
    end

    def tweet(conference)
      return unless Rails.env.production?
      return if conference.tweeted_at.present?
      return if conference.twitter.blank?
      return if conference.start_date.nil? or conference.start_date < Date.today

      conference.tweeted_at = DateTime.now
      conference.save

      @client.update(tweet_message(conference))
    end

    private

    def tweet_message(conference)
      <<~PRBODY
        Hey #{conference.twitter}! We've just added #{conference.name} to Confs.tech!
        => #{confs_url(conference)} 🎉 <=
        #{conference.topics.map{ |topic| "##{topic.name}"}.join(" ")}
      PRBODY
    end

    def confs_url(conference)
      main_topic = conference.topics.first
      topics = conference.topics.map(&:name).join("+")
      "https://confs.tech/#{main_topic.name}?topics=#{topics}"
    end
  end
end
