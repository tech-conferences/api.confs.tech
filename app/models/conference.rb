class Conference
  include ActiveModel::Model
  include DateConcern

  attr_accessor(
    :id,
    :name,
    :url,
    :city,
    :country,
    :startDate,
    :endDate,
    :cfpStartDate,
    :cfpEndDate,
    :cfpUrl,
    :topics,
    :languages,
    :size,
    :speakers,
    :twitter,
    :facebook
  )

  date_accessor(
    :startDate,
    :endDate,
    :cfpStartDate,
    :cfpEndDate,
  )

  validates :name, :url, :startDate, presence: true

  # Legacy mapping support
  def date=(value); self.startDate = value; end
  def cfpDate=(value); self.cfpStart = value; end

  def as_json(*args)
    super(*args)
      .except(:id)
      .merge(
        objectID: id,
        startDateUnix: startDateUnix,
        endDateUnix: endDateUnix,
        cfpStartDateUnix: cfpStartDateUnix,
        cfpEndDateUnix: cfpEndDateUnix,
      )
  end
end
