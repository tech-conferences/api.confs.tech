class URLHelper
  def self.fix_url url
    return nil if url.nil?
    url = url.strip
    url = url.gsub(/^https?:\/\//, '')
    "http://#{url}".gsub(/\/$/, '')
  end
end
