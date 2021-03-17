RSpec.describe CitySanatizerService, type: :service do
  let(:country) { 'Germany' }

  subject do
    CitySanatizerService.run!(city, country)
  end

  context 'is online' do
    let(:city) { 'Online' }

    it 'returns online' do
      expect(subject).to eq 'online'
    end
  end

  context 'city is Munchen' do
    let(:city) { 'München' }

    it 'returns Munich' do
      expect(subject).to eq 'Munich'
    end
  end

  context 'country is US' do
    let(:country) { 'U.S.A.' }

    context 'city is in list' do
      let(:city) { 'Las Vegas' }

      it 'returns the city with state' do
        expect(subject).to eq 'Las Vegas, NV'
      end
    end

    context 'city is not in list' do
      let(:city) { 'Lasss Vegas' }

      it 'returns the city with state' do
        expect(subject).to eq 'Lasss Vegas'
      end
    end
  end
end
