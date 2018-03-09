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
  before_validation :set_uuid
  after_save :algolia_index

  def self.create_or_update(attributes, topic)
    conference = self.new(attributes)
    conference.topics << topic
    if conference.valid?
      conference.save
      conference
    else
      existing_conf = Conference.where(uuid: conference.get_uuid).first
      unless existing_conf.topics.include? topic
        existing_conf.topics << topic
        existing_conf.save
      end
      existing_conf.assign_attributes attributes
      if existing_conf.changed?
        existing_conf.save
        existing_conf
      end
    end
  end

  def get_uuid
    Digest::SHA1.base64digest "#{name}-#{URI.parse(url).host}-#{startDate}-#{city}"
  end

  def set_uuid
    self.uuid ||= get_uuid
  end

  # Legacy mapping support
  def date=(value); self.startDate = value; end
  def cfpDate=(value); self.cfpStart = value; end

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
      )
  end

  private

  def algolia_index
    Algolia::SyncConferences.new(self).execute
  end
end
