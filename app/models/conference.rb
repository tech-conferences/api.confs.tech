class Conference
  CONFERENCE_ATTRIBUTES =
    :name,
    :url,
    :start_date,
    :end_date,
    :city,
    :country,
    :cfpEndDate,
    :cfpUrl,
    :type

  attr_accessor(*CONFERENCE_ATTRIBUTES)

  def initialize(*conference)
    conference.map do |key, value|
      underscored_key = key.to_s.underscore
      return unless CONFERENCE_ATTRIBUTES.include? underscored_key.to_sym
      self.send "#{underscored_key}=", value
    end
  end

  def id
    "#{url}-#{start_date}"
  end

  def as_json
    super.merge(
      objectID: id
    )
  end
end
