# frozen_string_literal: true

require 'bodysnatcher/version'
require 'typhoeus'
require 'nokogiri'

module Bodysnatcher
  # Represents a link.
  # Holds the url itself and where it was found.
  class Link
    attr_reader :url
    attr_reader :origin

    def initialize(url, origin)
      @url = url
      @origin = origin
    end

    def hash
      [url, origin].hash
    end

    def eql?(other)
      hash == other.hash
    end
  end

  # The meaty part of this program.
  # Visits every link it can, beginning with root.
  # Gathers dead links and prints them out at the end.
  class Walker
    attr_reader :root
    attr_reader :to_visit
    attr_reader :visited_urls
    attr_reader :dead

    def initialize(root,
                   to_visit = Set[Link.new(root, '')],
                   visited_urls = Set[],
                   dead = {})
      @root = root
      @to_visit = to_visit
      @visited_urls = visited_urls
      @dead = dead
    end

    def walk
      visit_all until to_visit.empty?
      puts "#{dead.count} dead links:"
      dead.each do |link, response|
        puts "#{link.url} broken on #{link.origin}"\
             " - #{response.code} #{response.status_message}"
      end
    end

    private

    def get(url = root)
      visited_urls.add url
      to_visit.to_a.each do |link|
        to_visit.delete link if link.url == url
      end
      Typhoeus.get url
    end

    def get_body(url = root)
      response = get url
      Nokogiri::HTML response.body
    end

    def absolutify(url, root = self.root)
      if %r{^([a-z]+://|//)}i =~ url
        url
      else
        root + url
      end
    end

    def should_be_visited(url, root = self.root)
      url.start_with?(root) && !url.include?('#')
    end

    def get_links_from(site = root)
      get_body(site).search('a').each do |url|
        url = absolutify(url.attribute('href').to_s)
        unless visited_urls.include?(url) || !should_be_visited(url)
          link = Link.new(url, site)
          to_visit.add link
        end
      end
    end

    def visit(link)
      url = link.url

      puts "Probing #{url}"
      url = absolutify(url)
      response = get url

      if response.success?
        get_links_from url
        return
      end
      dead[link] = response
    end

    def visit_all
      to_visit.to_a.each do |link|
        visit link
      end
    end
  end
end
