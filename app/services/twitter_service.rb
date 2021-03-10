class TwitterService < ApplicationService
  def initialize; end

  def tweet(conference)
    return unless Rails.env.production?
    return if conference.tweeted_at.present?
    return if conference.start_date.nil? || (conference.start_date < Date.today)

    client.update(tweet_message(conference))

    conference.tweeted_at = DateTime.now
    conference.save
  end

  def tweet_message(conference)
    # Name & date
    tweet = "#{conference.name} is happening on #{conference.start_date.strftime('%B, %-d')}."

    # Location
    tweet << "\n📍 "
    tweet << "#{conference.city}, #{conference.country}" if conference.city && conference.country
    tweet << ' & ' if conference.online? && conference.country
    tweet << 'Online' if conference.online?

    # Url
    tweet << "\n— #{conference.url}"

    # Cfp
    if conference.cfpUrl.present? && conference.cfp_end_date.present?
      tweet << "\n\nSubmit your proposal for a talk at #{conference.cfpUrl} before #{conference.cfp_end_date.strftime('%B, %-d')}."
    end

    # Hashtags
    topics = conference.topics.reject { |topic| topic.name == 'general' }
    tweet << "\n#tech #conference #{topics.map { |topic| "##{topic.name}" }.join(' ')}"

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

  def confs_url(conference)
    main_topic = conference.topics.first
    topics = conference.topics.map(&:name).join('%2B')
    "https://confs.tech/#{main_topic.name}?topics=#{topics}##{conf_id(conference)}"
  end

  def conf_id(conference)
    "#{conference.name.downcase.tr(' ', '-')}-#{conference.start_date}"
  end
end
