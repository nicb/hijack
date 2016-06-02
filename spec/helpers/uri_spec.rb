require 'spec_helper'

include Hijack::Helpers::URI

class TestObject
  attr_reader :base, :page

  def initialize
    proto = Forgery(:basic).boolean ? 'https:/' : 'http:/'
    @base = [ proto, Forgery(:internet).domain_name ].join('/')
    sfx =  Forgery(:basic).boolean ? 'html' : 'php'
    @page = [ build_page, sfx ].join('.')
  end

  def full_uri
    [self.base, self.page].join('/')
  end

private

  def build_page
    level = Forgery(:basic).number(:at_least => 1, :at_most => 7)
    res = []
    level.times { res << Forgery(:basic).text }
    res.join('/')
  end

end

describe 'Hijack::Helpers::URI#normalize' do

  before :example do
    @num_samples = 50
  end

  it 'normalizes uri' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect(normalize(to.page, to.base)).to eq(to.full_uri), "n.#{n} (base: #{to.base}, page: #{to.page})"
    end
  end

  it 'wont re-normalize already normalized uris' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect(normalize(to.full_uri, to.base)).to eq(to.full_uri), "n.#{n} (base: #{to.base}, page: #{to.page})"
    end
  end

end

describe 'Hijack::Helpers::URI#strip' do

  before :example do
    @num_samples = 50
  end

  it 'strips uris' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect(strip(to.full_uri)).to eq(to.page), "n.#{n} (base: #{to.base}, page: #{to.page})"
    end
  end

  it 'will return empty strings for bare domain names' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect(strip(to.base)).to eq(''), "n.#{n} (base: #{to.base})"
    end
  end

  it 'will return empty strings for bare domain names even if they have a slash at the end' do
    @num_samples.times do
      |n|
      to = TestObject.new
      slashed_base = to.base + '/'
      expect(strip(slashed_base)).to eq(''), "n.#{n} (base: #{slashed_base}, result: #{strip(slashed_base)})"
    end
  end

end

