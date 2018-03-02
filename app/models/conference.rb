class Conference
  include ActiveModel::Model

  attr_accessor(
    :id,
    :name,
    :url,
    :startDate,
    :endDate,
    :city,
    :country,
    :cfpStartDate,
    :cfpEndDate,
    :cfpUrl,
    :cfpStart,
    :topics,
    :languages,
    :size,
    :speakers,
    :twitter,
    :facebook
  )

  validates :name, :url, :startDate, presence: true

  def date
    return 0 unless startDate
    Date.parse(startDate.length == 10 ? startDate : "#{startDate}-01").to_time.to_i
  end

  def cfpDate
    return 0 unless cfpEndDate
    Date.parse(cfpEndDate.length == 10 ? cfpEndDate : "#{cfpEndDate}-01").to_time.to_i
  end

  def as_json(*args)
    super(*args).except(:id).merge(
      objectID: id,
      date: date,
      cfpDate: cfpDate,
    )
  end
end
