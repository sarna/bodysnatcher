# frozen_string_literal: true

RSpec.describe Bodysnatcher do
  let(:url) { 'http://test_url' }
  let(:origin) { 'test-origin' }

  it 'has a version number' do
    expect(Bodysnatcher::VERSION).not_to be nil
  end

  describe 'Link' do
    describe '#url' do
      it 'returns url' do
        link = Bodysnatcher::Link.new(url, origin)

        expect(link.url).to eq(url)
      end
    end

    describe '#origin' do
      it 'returns origin' do
        link = Bodysnatcher::Link.new(url, origin)

        expect(link.origin).to eq(origin)
      end
    end

    describe '#host' do
      it 'returns hash for the link' do
        link = Bodysnatcher::Link.new(url, origin)

        expect(link.hash).not_to be_nil
      end
    end

    describe 'eql?' do
      it 'returns true if the link is same' do
        link1 = Bodysnatcher::Link.new(url, origin)
        link2 = Bodysnatcher::Link.new(url, origin)

        expect(link1.eql?(link2)).to be true
      end

      it 'returns false if the link is same' do
        another_origin = 'test_origin'
        another_url = 'test_url'
        link1 = Bodysnatcher::Link.new(url, origin)
        link2 = Bodysnatcher::Link.new(another_url, another_origin)

        expect(link1.eql?(link2)).to be false
      end
    end
  end
end
