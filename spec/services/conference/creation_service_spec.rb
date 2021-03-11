RSpec.describe Conference::CreationService, type: :service do
  let(:basic_conference_params) do
    {
      name: 'Name',
      url: 'nimz.co',
      startDate: '2018-04-01',
      endDate: '2018-04-01',
      city: 'Nice',
      country: 'France',
      topic: 'javascript'
    }
  end
  let(:conference_params) { basic_conference_params }

  before do
    stub_request(:get, 'https://api.github.com/repos/tech-conferences/conference-data/git/refs/heads')
      .to_return(status: 200, body: [
        {
          ref: 'refs/heads/main',
          object: {
            sha: 'apzodjazpdoj'
          }
        }
      ].to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:post, 'https://api.github.com/repos/tech-conferences/conference-data/git/refs')
      .to_return(status: 200, body: [{}].to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:put, 'https://api.github.com/repos/tech-conferences/conference-data/contents/conferences/2018/javascript.json')
      .to_return(status: 200, body: [{}].to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:post, 'https://api.github.com/repos/tech-conferences/conference-data/pulls')
      .to_return(status: 200, body: [{}].to_json, headers: { 'Content-Type' => 'application/json' })

    subject.run!(params: conference_params)
  end

  describe 'with cfp' do
    let(:conference_params) {
      basic_conference_params.merge({
        cfpUrl: 'https://confs.tech/cfp'
      })
    }

    it 'posts the correct message to the PR' do
      expected_message = <<~PRBODY
        ## Conference information

        Website: <a href="http://nimz.co" target="_blank">http://nimz.co</a>
        CFP: <a href="https://confs.tech/cfp" target="_blank">https://confs.tech/cfp</a>


        ```json
        // javascript

        {
          "name": "Name",
          "url": "http://nimz.co",
          "startDate": "2018-04-01",
          "endDate": "2018-04-01",
          "city": "Nice",
          "country": "France",
          "cfpUrl": "https://confs.tech/cfp"
        }
        ```
      PRBODY

      expect(subject.send(:pr_body)).to eq expected_message.strip
    end
  end

  describe 'with twitter' do
    let(:conference_params) {
      basic_conference_params.merge({
        twitter: '@nimz_co'
      })
    }

    it 'posts the correct message to the PR' do
      expected_message = <<~PRBODY
        ## Conference information

        Website: <a href="http://nimz.co" target="_blank">http://nimz.co</a>

        Twitter: <a href="https://twitter.com/@nimz_co" target="_blank">https://twitter.com/@nimz_co</a>

        ```json
        // javascript

        {
          "name": "Name",
          "url": "http://nimz.co",
          "startDate": "2018-04-01",
          "endDate": "2018-04-01",
          "city": "Nice",
          "country": "France",
          "twitter": "@nimz_co"
        }
        ```
      PRBODY

      expect(subject.send(:pr_body)).to eq expected_message.strip
    end
  end
end
