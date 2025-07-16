module UrlHelper
  def self.fix_url(url)
    # Basic stub: ensure url starts with http(s)
    return nil if url.nil?
    url =~ /^https?:\/\// ? url : "https://#{url}"
  end
end
