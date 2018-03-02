namespace :algolia do
  desc "sync data from github with algolia"
  task sync: :environment do
    Algolia::SyncConferences.run
  end
end
