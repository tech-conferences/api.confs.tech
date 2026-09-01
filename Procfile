release: bin/rails db:migrate
web: bin/rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekick -C config/sidekiq.yml -q default
