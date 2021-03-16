class CountrySanatizerService < ApplicationService
  class << self
    delegate :run!, to: :new
  end

  def run!(country_name)
    case country_name.downcase
    when 'the netherlands', 'nl'
      return 'Netherlands'
    when 'u.s.', 'us', 'usa', 'u.s.a', 'united states', 'united states of america'
      return 'U.S.A.'
    when 'uk', 'uk.', 'u.k', 'uk', 'united kingdom', 'england'
      return 'U.K.'
    when 'deutschland'
      return 'Germany'
    when 'korea'
      return 'South Korea'
    when 'uae', 'u.a.e.'
      return 'United Arab Emirates'
    end

    country_name.humanize
  end
end
