class Topic < ActiveRecord::Base
  has_and_belongs_to_many :conferences

  def self.related_topic(topic)
    case topic.name
    when "typescript", "elm"
      self.find_by_name('javascript')
    when "scala", "groovy"
      self.find_by_name('java')
    else
      nil
    end
  end
end
