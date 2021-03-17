class CountrySanatizerService < ApplicationService
  class << self
    delegate :run!, to: :new
  end

  def run!(country)
    return 'online' if country.downcase == 'online'

    case country.downcase
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
    when 'columbia'
      return 'Colombia'
    end

    country.titleize
  end
end
