RSpec.describe Conference::CreationService, type: :service do
  describe 'with bad topic' do
    it 'fails' do
      stub_request(:get, 'https://api.github.com/repos/tech-conferences/conference-data/git/refs/heads')
        .to_return(status: 200, body: {}.to_json, headers: {})

      # subject.run!(params: conference_params)
    end
  end

  describe 'with bad dates' do
    it 'fails'
  end

  describe 'with missing keys' do
    it 'fails'
  end

  private

  def conference_params
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
end
