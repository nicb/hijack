require 'spec_helper'

include Hijack::Helpers::URI

class TestObject
  attr_reader :base, :page, :sfx

  SUFFIXES = [ nil, '.html', '.php', '.pdf', '.mp3' ]

  def initialize
    @base = generate_base
    @sfx = SUFFIXES[Forgery(:basic).number(at_least: 0, at_most: SUFFIXES.size-1)]
    @page = [ build_page, @sfx ].compact.join
  end

  def full_uri
    [self.base, self.page].join('/')
  end

private

  def generate_base
    protos = [ 'http://', 'https://', 'ftp://', 'mailto:' ]
    idx = Forgery(:basic).number(at_least: 0, at_most: protos.size-1)
    proto = protos[idx]
    url_method = proto == 'mailto:' ? :email_address : :domain_name
    [ proto, Forgery(:internet).send(url_method) ].join
  end

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
    #
    # let's make sure that it won't put double uris
    #
    @num_samples.times do
      |n|
      to = TestObject.new
      to2 = TestObject.new
      expect(normalize(to.full_uri, to2.full_uri)).to eq(to.full_uri), "n.#{n} (base: #{to.base}, page: #{to.page})"
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
      expect((res = strip(to.full_uri))).to eq([to.page, to.base]), "n.#{n} (base: #{to.base}, page: #{to.page}) != #{res}"
    end
  end

  it 'will return empty strings for bare domain names' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect((res = strip(to.base))).to eq(['', to.base]), "n.#{n} (base: #{to.base}) != #{res}"
    end
  end

  it 'will return empty strings for bare domain names even if they have a slash at the end' do
    @num_samples.times do
      |n|
      to = TestObject.new
      slashed_base = to.base + '/'
      expect((res = strip(slashed_base))).to eq(['', slashed_base]), "n.#{n} (base: #{slashed_base}, result: #{res}) != ['', #{slashed_base}]"
    end
  end

  it 'will return bare pages and no base name if relative' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect((res = strip(to.page))).to eq([to.page, '']), "n.#{n} result: #{res} != [#{to.page}, '']"
    end
  end

  it 'will return bare pages and no base name if relative' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect((res = strip(to.page))).to eq([to.page, '']), "n.#{n} result: #{res} != [#{to.page}, '']"
    end
  end

end

describe 'Hijack::Helpers::URI#same_base?' do

  before :example do
    @num_samples = 50
  end

  it 'can track uris with different bases' do
    @num_samples.times do
      |n|
      to0 = TestObject.new
      to1 = TestObject.new
      result = to0.base == to1.base
      expect((res = same_base?(to0.full_uri, to1.full_uri))).to eq(result), "n.#{n} (0: #{to0.full_uri}, 1: #{to1.full_uri}) != #{result}"
    end
  end

  it 'can track uris with same bases' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect((res = same_base?(to.full_uri, to.full_uri))).to eq(true), "n.#{n} (0: #{to.full_uri}, 1: #{to.full_uri}) != #{true}"
    end
  end

  it 'can track different bases' do
    @num_samples.times do
      |n|
      to0 = TestObject.new
      to1 = TestObject.new
      result = to0.base == to1.base
      expect((res = same_base?(to0.full_uri, to1.base))).to eq(result), "n.#{n} (0: #{to0.full_uri}, 1: #{to1.full_uri}) != #{result}"
    end
  end

  it 'can track same bases' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect((res = same_base?(to.full_uri, to.base))).to eq(true), "n.#{n} (0: #{to.full_uri}, 1: #{to.full_uri}) != #{true}"
    end
  end

end

describe 'Hijack::Helpers::URI#relative?' do

  before :example do
    @num_samples = 50
  end

  it 'responds false to full uris' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect((res = relative?(to.full_uri))).to eq(false), "n.#{n}: #{to.full_uri} != false (#{res})"
    end
  end

  it 'responds true to relative uris' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect((res = relative?(to.page))).to eq(true), "n.#{n} 0: #{to.page} != true (#{res})"
    end
  end

end

describe 'Hijack::Helpers::URI#suffix' do

  before :example do
    @num_samples = 50
  end

  it 'returns the proper suffix' do
    @num_samples.times do
      |n|
      to = TestObject.new
      expect((res = suffix(to.full_uri))).to eq(to.sfx), "n.#{n}: '#{res}' != '#{to.sfx}' (page: '#{to.full_uri}')"
    end
  end

end
