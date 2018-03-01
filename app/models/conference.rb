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

  def id
    Digest::SHA1.base64digest "#{url}-#{startDate}"
  end

  def as_json(*args)
    super(*args).merge(
      objectID: id
    )
  end
end
