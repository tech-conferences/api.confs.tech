require 'open-uri'

APPLICATION_ID = '8MN5N7L4M3'
API_KEY = 'fc9ac0af9e5feec3531031b37d239cbc'
ALGOLIA_INDEX_NAME = 'conferences'

DEFAULT_URL = 'https://raw.githubusercontent.com/tech-conferences/confs.tech/master/conferences'
START_YEAR = 2017
RAW_CONTENT_URLS = {
  javascript: 'https://raw.githubusercontent.com/tech-conferences/javascript-conferences/master/conferences',
  css: DEFAULT_URL,
  php: DEFAULT_URL,
  ux: DEFAULT_URL,
  ruby: DEFAULT_URL,
  ios: DEFAULT_URL,
  android: DEFAULT_URL,
  general: DEFAULT_URL,
}

class ConferenceLoader
  def self.load
    conferences = []
    RAW_CONTENT_URLS.map do |tech, url|
      (START_YEAR..Date.today.year).map do |year|
        begin
          JSON.load(open("#{url}/#{year}/#{tech}.json")).map do |conference|
            conference['type'] = tech
            conferences << Conference.new(*conference)
          end
        rescue OpenURI::HTTPError
          []
        end
      end
    end
    conferences
  end

  def self.index(conferences)
    Algolia.init application_id: APPLICATION_ID, api_key: API_KEY
    index = Algolia::Index.new(ALGOLIA_INDEX_NAME)
    index.add_objects(conferences.map(&:as_json))
  end
end
