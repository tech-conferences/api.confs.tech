class Topic < ApplicationRecord
  has_and_belongs_to_many :conferences

  def self.related_topic(topic)
    case topic.name
    when 'typescript', 'elm'
      find_by(name: 'javascript')
    when 'scala', 'groovy'
      find_by(name: 'java')
    else
      nil
    end
  end
end
