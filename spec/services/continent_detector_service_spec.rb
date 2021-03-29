RSpec.describe ContinentDetectorService, type: :service do
  let(:country) { 'France' }

  subject do
    ContinentDetectorService.run!(country)
  end

  context 'country is in list' do
    it 'returns a continent' do
      expect(subject).to eq('Europe')
    end
  end

  context 'country is not in list' do
    let(:country) { 'Nope' }

    it 'returns nil' do
      expect(subject).to eq(nil)
    end
  end
end
