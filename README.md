# README

## Configuration

Set the configuration you want in `config/application.rb`:

* `gh_token`: GitHub authorization token
* `gh_repo`: GitHub repository

### Testing

As for now, feature set is limited, but you can hit the following endpoint:

* `/`: List all the closed Pull-Requests on the repository
* `/github/create`: Create a Pull-Request under the `gh_repo`
