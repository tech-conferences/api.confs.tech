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
      return if conference.start_date.nil? or conference.start_date < Date.today

      conference.tweeted_at = DateTime.now
      conference.save

      @client.update(tweet_message(conference))
    end

    private

    def tweet_message(conference)
      if conference.twitter.present?
        <<~PRBODY
          We've just added #{conference.name}! Happening #{conference.start_date.strftime('%B, %e')} in #{conference.city}, #{conference.country}
          => #{confs_url(conference)}
          cc #{conference.twitter}!  🎉
          #{conference.topics.map{ |topic| "##{topic.name}"}.join(" ")}
        PRBODY
      else
        <<~PRBODY
          We've just added #{conference.name}! Happening #{conference.start_date.strftime('%B, %e')} in #{conference.city}, #{conference.country}
          => #{confs_url(conference)} 🎉
          #{conference.topics.map{ |topic| "##{topic.name}"}.join(" ")}
        PRBODY
      end
    end

    def confs_url(conference)
      main_topic = conference.topics.first
      topics = conference.topics.map(&:name).join("%2B")
      "https://confs.tech/#{main_topic.name}?topics=#{topics}##{conf_id(conference)}"
    end

    def conf_id(conference)
      "#{conference.name.downcase.gsub(' ', '-')}-#{conference.start_date}"
    end
  end
end
