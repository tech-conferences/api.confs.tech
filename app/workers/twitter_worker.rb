class TwitterWorker
  include Sidekiq::Worker

  def perform(conference)
    Twitter::TwitterService.new.tweet(conference)
  end
end
