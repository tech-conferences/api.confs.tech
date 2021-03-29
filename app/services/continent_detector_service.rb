class ContinentDetectorService < ApplicationService
  class << self
    delegate :run!, to: :new
  end
  CONTINENTS = {
    'Africa': [
      'Egypt',
      'Ghana',
      'Kenya',
      'Mauritius',
      'Morocco',
      'Nigeria',
      'South Africa',
      'Tanzania'
    ],
    'Oceania': [
      'Australia',
      'New Zealand'
    ],
    'Europe': [
      'Armenia',
      'Austria',
      'Belarus',
      'Belgium',
      'Bosnia and Herzegovina',
      'Bulgaria',
      'Croatia',
      'Cyprus',
      'Czech Republic',
      'Denmark',
      'Estonia',
      'Ethiopia',
      'Finland',
      'France',
      'Germany',
      'Greece',
      'Hungary',
      'Iceland',
      'Ireland',
      'Italy',
      'Kosovo',
      'Latvia',
      'Lithuania',
      'Moldova',
      'Netherlands',
      'Norway',
      'Poland',
      'Portugal',
      'Romania',
      'Russia',
      'Scotland',
      'Serbia',
      'Slovakia',
      'Slovenia',
      'Spain',
      'Sweden',
      'Switzerland',
      'Turkey',
      'U.K.',
      'Ukraine'
    ],
    'Americas': [
      'Argentina',
      'Bolivia',
      'Brazil',
      'Canada',
      'Chile',
      'Colombia',
      'Cuba',
      'Dominican Republic',
      'Guatemala',
      'Jamaica',
      'Mexico',
      'Panama',
      'Peru',
      'Puerto Rico',
      'U.S.A.',
      'Uruguay'
    ],
    'Asia': [
      'Bangladesh',
      'China',
      'Hong Kong',
      'India',
      'Indonesia',
      'Iran',
      'Israel',
      'Japan',
      'Jordan',
      'Korea',
      'Malaysia',
      'Nepal',
      'Philippines',
      'Qatar',
      'Singapore',
      'South Korea',
      'Sri Lanka',
      'Taiwan',
      'Thailand',
      'United Arab Emirates',
      'Vietnam'
    ]
  }.freeze

  def run!(country)
    CONTINENTS.keys.detect do |continent|
      return continent.to_s if CONTINENTS[continent].find_index(country)
    end
  end
end
