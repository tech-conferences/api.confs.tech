class TwitterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(conference)
    TwitterService.new.tweet(conference)
  end
end
