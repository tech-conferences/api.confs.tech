class GithubController < ApplicationController
  def index
    client = Octokit::Client.new(:access_token => "02ae24928156050cdf5799fa6a39ca943675a2b7")
    pull_requests = client.pull_requests('tech-conferences/confs.tech', :state => 'closed')
    render json: { status: 200,
                    data: pull_requests }
  end

end
