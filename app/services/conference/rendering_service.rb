class Conference::RenderingService < ApplicationService
  class << self
    delegate :run!, to: :new
  end

end
