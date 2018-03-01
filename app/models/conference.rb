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
    :type,
    :language,
    :size,
    :speakers,
    :twitter,
    :facebook
  )

  validates :name, :url, :startDate, presence: true

  def id
    Digest::SHA1.base64digest "#{url}-#{startDate}"
  end

  def as_json
    super.merge(
      objectID: id
    )
  end
end
