class Conference
  include ActiveModel::Model

  attr_accessor(
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
    if startDate.length == 10
      Date.parse(startDate).to_time.to_i
    else
      Date.parse("#{startDate}-01").to_time.to_i
    end
  end

  def id
    Digest::SHA1.base64digest "#{url}-#{startDate}"
  end

  def as_json(*args)
    super(*args).merge(
      objectID: id,
      date: date,
    )
  end
end
