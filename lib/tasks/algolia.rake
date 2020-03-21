namespace :algolia do
  desc "sync data from github with algolia"
  task sync: :environment do
    FetchConferencesService.run
  end
end
