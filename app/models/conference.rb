class Conference < ApplicationRecord
  include ActiveModel::Dirty
  include DateConcern

  default_scope { order(created_at: :desc) }

  date_accessor(
    :startDate,
    :endDate,
    :cfpStartDate,
    :cfpEndDate
  )

  has_and_belongs_to_many :topics

  validates :name, :url, :startDate, presence: true
  validates :uuid, uniqueness: { case_sensitive: true }
  before_validation :set_uuid, :fix_url

  before_save :add_related_topic
  before_save :update_start_end_dates

  after_create :tweet

  before_destroy :algolia_remove

  after_save :algolia_index
  after_save :fetch_twitter_followers_count

  def self.create_or_update(attributes, topic)
    whitelised_attributes = self.whitelised_attributes(attributes)
    conference = new whitelised_attributes
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
    uuid_attrs = [URI.parse(url).host, URI.parse(url).path, startDate[0..6], city, offersSignLanguageOrCC, online]
    Digest::SHA1.base64digest uuid_attrs.join('-')
  end

  def set_uuid
    self.uuid ||= get_uuid
  end

  # Legacy mapping support
  def date=(value)
    self.startDate = value
  end

  def cfpDate=(value)
    self.cfpStart = value
  end

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
        hasDiscount: affiliateUrl.present?,
        continent: continent,
        locales: (locales || 'EN').split(',')
      )
  end

  def self.whitelised_attributes(attributes)
    whitelist_attr = {}
    attribute_names.map do |_attr|
      whitelist_attr[_attr] = attributes[_attr] if attributes[_attr]
    end
    whitelist_attr
  end

  @@email_regexp = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  def fetch_emails(_browser = nil)
    browser = _browser || Watir::Browser.new
    browser.goto url
    emails = browser.body.html.scan(@@email_regexp)
                    .reject { |e| /@(1|2|3)x/.match(e) or /your?@/.match(e) or /example.com/.match(e) }
                    .uniq
    self.emails = emails.any? ? emails.join(';') : "contact@#{URI.parse(url).host}".gsub('www.', '')
    save!
    browser.close unless _browser
  end

  def cfp_end_date
    return nil if cfpEndDate.blank?

    Date.parse(cfpEndDate)
  end

  def tweet_message
    TwitterService.new.tweet_message(self)
  end

  def location_to_s
    location = '📍 '

    location << "#{city}, #{country}" if city && country
    location << ' & ' if online? && country
    location << 'Online' if online?

    location
  end

  private

  def continent
    ContinentDetectorService.run!(country)
  end

  def update_start_end_dates
    self.start_date = startDate.present? && startDate.length === 10 ? Date.parse(startDate.split(/\D/).join('-')) : nil
    self.end_date = endDate.present? && endDate.length === 10 ? Date.parse(endDate.split(/\D/).join('-')) : nil
  rescue StandardError
  end

  def fetch_twitter_followers_count
    return unless Rails.env.production?
    return if twitter.blank? || twitter_followers.present?

    begin
      page = Nokogiri::HTML(open("https://twitter.com/#{twitter}"))
      followers = page.css('[data-nav="followers"] .ProfileNav-value').attr('data-count').value
      self.twitter_followers = followers.to_i
      save
    rescue Exception => e
    end
  end

  def fix_url
    self.url = URLHelper.fix_url(url) if url.present?
    self.cfpUrl = URLHelper.fix_url(cfpUrl) if cfpUrl.present?
    self.cocUrl = URLHelper.fix_url(cocUrl) if cocUrl.present?
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
      TwitterWorker.new.perform(self)
    rescue StandardError => e
    end
  end

  def add_related_topic
    related_topics = topics.map { |topic| Topic.related_topic(topic) }.compact.uniq
    return if related_topics.empty?

    self.topics = topics | related_topics
  end
end
