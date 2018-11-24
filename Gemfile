source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.1'
gem 'loofah', '~> 2.2.1'
gem 'puma', '~> 3.7'
gem 'simple_command'
gem 'algoliasearch'
gem 'chronic'
gem 'pg'
gem 'bugsnag'
gem 'twitter', '~> 6.2.0'
gem 'sidekiq', '~> 4.1.3'

# Ruby toolkit for the GitHub API
gem "octokit", "~> 4.0"
gem 'administrate'
gem 'uglifier'

gem 'devise'
gem 'watir'

# API
gem 'faraday'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', :require => 'rack/cors'

#
# JWT; Token-based authentication
gem 'jwt'

group :test do
  gem 'mocha', '1.7.0', require: false
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
