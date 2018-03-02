class Conference
  include ActiveModel::Model
  include DateConcern

  attr_accessor(
    :id,
    :name,
    :url,
    :city,
    :country,
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
    :cfpStart,
    :cfpEnd,
  )

  validates :name, :url, :startDate, presence: true

  #legacy mapping support
  def date=(value); self.startDate = value; end
  def cfpDate=(value); self.cfpStart = value; end

  def as_json(*args)
    super(*args).except(:id).merge(objectID: id)
  end
end
