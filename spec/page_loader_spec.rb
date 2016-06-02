require 'spec_helper'

describe Hijack::PageLoader do

  before :example do
    @remote_uris = { 'http://www.scelsi.it' => 'index.php' }
  end

  it 'can create itself' do
    @remote_uris.each do
      |base, page|
      expect((pl = Hijack::PageLoader.new(page, base)).class).to be(Hijack::PageLoader)
      expect(pl.pages.empty?).to be(true)
    end
  end

  it 'can suck an entire website', :slow => true do
    @remote_uris.each do
      |base, page|
      expect((pl = Hijack::PageLoader.new(page, base)).class).to be(Hijack::PageLoader)
      expect(pl.pages.empty?).to be(true)
      pl.suck
      expect(pl.pages.empty?).to be(false)
    end
  end

  it 'can suck a limited amount of pages' do
    limit = Forgery(:basic).number(:at_least => 3, :at_most => 8)
    @remote_uris.each do
      |base, page|
      expect((pl = Hijack::PageLoader.new(page, base)).class).to be(Hijack::PageLoader)
      expect(pl.pages.empty?).to be(true)
      pl.suck(limit)
      expect(pl.pages.empty?).to be(false)
      expect(pl.pages.size).to be >= limit
    end
  end

end
