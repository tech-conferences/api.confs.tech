class URLHelper
  def self.fix_url url
    url = url.strip
    if !url.match /^http(s?)\:\/\//
      "http://#{url}".gsub(/\/$/, '')
    else
      url
    end
  end
end
