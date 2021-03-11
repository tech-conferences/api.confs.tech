RSpec.describe TwitterService, type: :service do
  let(:tweet) { subject.send(:tweet_message, conference) }
  let(:basic_conference_params) do
    {
      name: 'Conference',
      url: 'https://web.dev',
      city: 'Nice',
      country: 'France',
      startDate: '2018-01-01',
      endDate: '2018-01-01'
    }
  end
  let(:conference_params) { basic_conference_params }

  let(:conference) { Conference.new(conference_params) }

  before do
    # Makes sure dates are converted to date objects
    conference.send :update_start_end_dates
  end

  describe 'online' do
    let(:conference_params) {
      basic_conference_params.merge({
        online: true,
        city: nil,
        country: nil
      })
    }

    it 'correctly renders the location' do
      conference.topics << Topic.new(name: 'ux')
      expected_message = <<~PRBODY
        Conference is happening on January, 1.
        📍 Online
        — https://web.dev
        #tech #conference #ux
      PRBODY
      expect(tweet).to eq expected_message.strip
    end
  end

  describe 'online & in situe' do
    let(:conference_params) {
      basic_conference_params.merge({
        online: true,
      })
    }

    it 'correctly renders the location' do
      conference.topics << Topic.new(name: 'ux')
      expected_message = <<~PRBODY
        Conference is happening on January, 1.
        📍 Nice, France & Online
        — https://web.dev
        #tech #conference #ux
      PRBODY
      expect(tweet).to eq expected_message.strip
    end
  end

  describe 'only in situe' do
    it 'correctly renders the location' do
      expected_message = <<~PRBODY
        Conference is happening on January, 1.
        📍 Nice, France
        — https://web.dev
        #tech #conference
      PRBODY
      expect(tweet).to eq expected_message.strip
    end
  end

  describe 'topics' do
    it 'shows 1 topic' do
      conference.topics << Topic.new(name: 'ux')
      expected_message = <<~PRBODY
        Conference is happening on January, 1.
        📍 Nice, France
        — https://web.dev
        #tech #conference #ux
      PRBODY
      expect(tweet).to eq expected_message.strip
    end

    it 'shows 2 topics' do
      conference.topics << Topic.new(name: 'ux')
      conference.topics << Topic.new(name: 'javascript')
      expected_message = <<~PRBODY
        Conference is happening on January, 1.
        📍 Nice, France
        — https://web.dev
        #tech #conference #ux #javascript
      PRBODY
      expect(tweet).to eq expected_message.strip
    end
  end

  describe 'with CFP' do
    let(:conference_params) {
      basic_conference_params.merge({
        cfpUrl: 'cfp.web.dev',
        cfpEndDate: '2019-01-01'
      })
    }

    it 'specifies the cfp dates' do
      conference.topics << Topic.new(name: 'ux')
      expected_message = <<~PRBODY
        Conference is happening on January, 1.
        📍 Nice, France
        — https://web.dev
        #tech #conference #ux

        Submit your proposal for a talk at cfp.web.dev before January, 1.
      PRBODY
      expect(tweet).to eq expected_message.strip
    end
  end
end
