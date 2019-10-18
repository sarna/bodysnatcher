# frozen_string_literal: true
require "spec_helper"

RSpec.describe Bodysnatcher, type: :model do
  it 'has a version number' do
    expect(Bodysnatcher::VERSION).to eq "0.1.0"
  end

  describe Bodysnatcher::Link do
  	let(:attr) do
      { 
      	url: "hello.com",
      	origin: "this"
     	}
  	end

	  describe '#initialize' do
	    it 'should get correct params' do
	    	
	    end
  	end

	  describe '#has' do
	    it 'should define hash' do
	    	
	    end
  	end

	  describe '#eql' do
	    it 'should be eqal with other hash' do
	    	
	    end
  	end
	end

	describe Bodysnatcher::Walker do
	  describe '#initialize' do
	    it 'should get correct params' do
	    	
	    end
  	end

	  describe '#walk' do
	    it 'should define hash' do
	    	
	    end
  	end

	  describe '#eql' do
	    it 'should be eqal with other hash' do
	    	
	    end
  	end
	end
end
