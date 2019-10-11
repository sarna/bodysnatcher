# frozen_string_literal: true

require 'bodysnatcher/version'
require 'typhoeus'
require 'nokogiri'

module Bodysnatcher
  # TODO
  # document this
  class Bodysnatcher
    attr_reader :root
    attr_reader :to_visit
    attr_reader :visited
    attr_reader :dead

    def initialize(root,
                   to_visit = Set[root],
                   visited = Set[],
                   dead = {})
      @root = root
      @to_visit = to_visit
      @visited = visited
      @dead = dead
    end

    def get(url = root)
      visited.add url
      to_visit.delete url
      Typhoeus.get url
    end

    def get_body(url = root)
      response = get url
      Nokogiri::HTML response.body
    end

    def get_links(url = root)
      get_body(url).search('a').each do |link|
        link = link.attribute('href').to_s
        link = make_link link
        unless visited.include?(link) || !should_be_visited(link)
          to_visit.add(link)
        end
      end
    end

    def make_link(link, root = self.root)
      if %r{^([a-z]+://|//)}i =~ link
        link
      else
        root + link
      end
    end

    def should_be_visited(link)
      link.start_with?(root) && !link.include?('#')
    end

    def visit(link)
      puts "Probing #{link}"
      link = make_link link
      response = get link

      if response.success?
        get_links link if should_be_visited link
        return
      end
      dead[link] = response
    end

    def visit_all
      to_visit.to_a.each do |link|
        visit link
      end
    end

    def walk
      visit_all until to_visit.empty?
      puts "#{dead.count} dead links:"
      dead.each do |link, response|
        puts "#{link} #{response.code} #{response.status_message}"
      end
    end
  end
end
