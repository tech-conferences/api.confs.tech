RSpec.describe CountrySanatizerService, type: :service do
  subject do
    CountrySanatizerService.run!(country)
  end

  context 'country not in the list' do
    let(:country) { 'Not in the list' }

    it 'returns the country when not in the list' do
      expect(subject).to eq country
    end
  end

  context 'country in the list' do
    let(:country) { 'usa' }

    it 'returns the sanatized country' do
      expect(subject).to eq 'U.S.A.'
    end
  end

  context 'capitalization' do
    let(:country) { 'canada' }

    it 'capitalize the country name' do
      expect(subject).to eq 'Canada'
    end
  end
end
