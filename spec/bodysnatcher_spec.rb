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

    describe 'Walker' do
      describe '#walk' do
        it 'returns empty list when there are no dead links' do
          VCR.use_cassette('no_dead_links') do
            walker = Bodysnatcher::Walker.new('http://localhost:8080/')
            dead_links = walker.walk

            expect(dead_links).to be_empty
          end
        end

        it 'returns dead links when link is not working' do
          root = 'http://localhost:8080/'
          url1 = 'http://localhost:8080/names'
          url2 = 'http://localhost:3000/names'

          links = [Bodysnatcher::Link.new(url2, ''),
                   Bodysnatcher::Link.new(url1, '')]

          VCR.use_cassette('with_dead_links') do
            walker = Bodysnatcher::Walker.new(root, links)
            dead_links = walker.walk

            expect(dead_links).not_to be_empty
            expect(dead_links.count).to eq(1)
            expect(dead_links.first.first.url).to eq(url2)
          end
        end
      end
    end
  end
end
