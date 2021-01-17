class TwitterService < ApplicationService
  def initialize
  end

  def tweet(conference)
    return unless Rails.env.production?
    return if conference.tweeted_at.present?
    return if conference.start_date.nil? or conference.start_date < Date.today

    client.update(tweet_message(conference))

    conference.tweeted_at = DateTime.now
    conference.save
  end

  def tweet_message(conference)
    tweet = <<~PRBODY
      #{conference.name} is happening on #{conference.start_date.strftime('%B, %-d')} in #{conference.city}, #{conference.country}
      => #{conference.url}
    PRBODY

    if conference.cfpUrl.present? and conference.cfp_end_date.present?
      tweet << <<~PRBODY
        Submit your proposal for a talk at #{conference.cfpUrl} before #{conference.cfp_end_date.strftime('%B, %-d')}.
      PRBODY
    end

    topics = conference.topics.reject{|topic| topic.name == 'general'}
    tweet << <<~PRBODY
      #tech #conference #{topics.map{ |topic| "##{topic.name}"}.join(" ")}
    PRBODY
    tweet.strip
  end

  private

  def client
    @client ||= ::Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET_KEY']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
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
