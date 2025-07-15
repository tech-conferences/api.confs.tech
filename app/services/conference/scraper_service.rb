require 'nokogiri'
require 'open-uri'

module ConferenceScraper
  class ScraperService
    def self.scrape(url)
      begin
        html = URI.open(url)
        doc = Nokogiri::HTML(html)
        # Simple extraction logic (customize selectors as needed)
        title = doc.at('title')&.text || doc.at('h1')&.text
        date = doc.at('[itemprop*="startDate"], .date, .event-date')&.text
        location = doc.at('[itemprop*="location"], .location, .event-location')&.text
        {
          title: title&.strip,
          date: date&.strip,
          location: location&.strip
        }
      rescue => e
        { error: e.message }
      end
    end
  end
end
