RSpec.describe Conferences::CreationService do
  describe 'with bad topic' do
    it 'fails'
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
