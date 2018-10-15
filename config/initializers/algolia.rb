Algolia.init(
  application_id: Rails.application.secrets.algolia_id || ENV['algolia_id'],
  api_key: Rails.application.secrets.algolia_api_key || ENV['algolia_api_key']
) unless Rails.env.tests?
