class Conference < ActiveRecord::Base
  include ActiveModel::Dirty
  include DateConcern

  date_accessor(
    :startDate,
    :endDate,
    :cfpStartDate,
    :cfpEndDate,
  )

  has_and_belongs_to_many :topics
  validates :name, :url, :startDate, presence: true
  validates :uuid, uniqueness: {case_sensitive: true}
  before_validation :set_uuid, :fix_url

  after_create :tweet
  before_save :add_related_topic
  before_save :update_start_end_dates
  after_save :algolia_index
  after_save :fetch_twitter_followers_count
  before_destroy :algolia_remove

  def self.create_or_update(attributes, topic)
    whitelised_attributes = self.whitelised_attributes(attributes)
    conference = self.new whitelised_attributes
    conference.topics << topic
    if conference.valid?
      conference.save!
      conference
    else
      existing_conf = Conference.where(uuid: conference.get_uuid).first
      unless existing_conf.topics.include? topic
        existing_conf.topics << topic
        existing_conf.save!
      end
      existing_conf.assign_attributes whitelised_attributes
      if existing_conf.changed?
        existing_conf.save!
        existing_conf
      end

      existing_conf
    end
  end

  def get_uuid
    Digest::SHA1.base64digest "#{URI.parse(url).host}-#{URI.parse(url).path}-#{startDate[0..6]}-#{city}"
  end

  def set_uuid
    self.uuid ||= get_uuid
  end

  # Legacy mapping support
  def date=(value); self.startDate = value; end
  def cfpDate=(value); self.cfpStart = value; end

  def address
    if country == 'U.S.A.'
      [city.split(',').first, 'US'].compact.join(', ')
    else
      [city, country].compact.join(', ')
    end
  end

  def as_json(*args)
    super(*args)
      .except(:id)
      .merge(
        topics: topics.map(&:name),
        objectID: uuid,
        startDateUnix: startDateUnix,
        endDateUnix: endDateUnix,
        cfpStartDateUnix: cfpStartDateUnix,
        cfpEndDateUnix: cfpEndDateUnix,
        hasDiscount: affiliateUrl.present?
      )
  end

  def self.whitelised_attributes(attributes)
    whitelist_attr = {}
    self.attribute_names.map do |_attr|
      whitelist_attr[_attr] = attributes[_attr] if attributes[_attr]
    end
    whitelist_attr
  end

  @@email_regexp = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  def fetch_emails(_browser = nil)
    browser = _browser || Watir::Browser.new
    browser.goto self.url
    emails = browser.body.html.scan(@@email_regexp)
      .reject{|e| /@(1|2|3)x/.match(e) or /your?@/.match(e)  or /example.com/.match(e) }
      .uniq
    self.emails = emails.any? ? emails.join(';') : "contact@#{URI.parse(self.url).host}".gsub('www.', '')
    self.save!
    browser.close unless _browser
  end

  def cfp_end_date
    return nil unless cfpEndDate.present?
    Date.parse(cfpEndDate)
  end

  def tweet_message
    TwitterService.new.tweet_message(self)
  end

  private

  def update_start_end_dates
    begin
      self.start_date = startDate.present? && startDate.length === 10 ? Date.parse(startDate.split(/\D/).join('-')) : nil
      self.end_date = endDate.present? && endDate.length === 10 ? Date.parse(endDate.split(/\D/).join('-')) : nil
    rescue
    end
  end

  def fetch_twitter_followers_count
    return unless Rails.env.production?
    return if self.twitter.blank? or self.twitter_followers.present?

    begin
      page = Nokogiri::HTML(open("https://twitter.com/#{self.twitter}"))
      followers = page.css('[data-nav="followers"] .ProfileNav-value').attr('data-count').value
      self.twitter_followers = followers.to_i
      self.save
    rescue => e
    end
  end

  def fix_url
    self.url = URLHelper.fix_url(self.url) if self.url.present?
    self.cfpUrl = URLHelper.fix_url(self.cfpUrl) if self.cfpUrl.present?
  end

  def algolia_index
    SyncConferenceService.new(self).add if Rails.env.production?
  end

  def algolia_remove
    SyncConferenceService.new(self).remove if Rails.env.production?
  end

  def tweet
    return unless Rails.env.production?
    begin
      TwitterWorker.new.perform(self) if ENV.fetch('TWEET_CONFERENCES', false) == 'true'
    rescue => exception
    end
  end

  def add_related_topic
    related_topics = self.topics.map{ |topic| Topic.related_topic(topic) }.compact.uniq
    return if related_topics.empty?
    self.topics = self.topics | related_topics
  end
end
