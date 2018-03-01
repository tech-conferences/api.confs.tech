class ApplicationService
  def self.run(*args)
    new(*args).execute
  end

  def execute
    raise NoMethodError
  end
end
