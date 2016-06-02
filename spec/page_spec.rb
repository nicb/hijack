require 'spec_helper'

describe Hijack::Page do

  before :example do
    @remote_uris =
    {
       'http://www.scelsi.it' => 'Fondazione Isabella Scelsi',
       'https://www.google.com' => 'Google',
       'https://www.w3.org' => 'World Wide Web Consortium (W3C)',
    }
  end

  it 'can open remote URIs' do
    @remote_uris.keys.each do
      |uri|
      expect((p = Hijack::Page.new(uri)).class).to be(Hijack::Page)
      expect(p.html_content.nil?).to be(false)
      expect(p.html_content.class).to be(Nokogiri::HTML::Document)
    end
  end

  it 'returns the links to other pages' do
    @remote_uris.keys.each do
      |uri|
      expect((p = Hijack::Page.new(uri)).class).to be(Hijack::Page)
      expect(p.html_content.nil?).to be(false)
      expect(p.links.empty?).to be(false)
    end
  end

  it 'sports a title for each page' do
    @remote_uris.each do
      |uri, title|
      expect((p = Hijack::Page.new(uri)).class).to be(Hijack::Page)
      expect(p.html_content.nil?).to be(false)
      expect(p.title).to eq(title)
    end
  end

  it 'makes a unique checksum for each page' do
    checksums = []
    @remote_uris.keys.each do
      |uri|
      expect((p = Hijack::Page.new(uri)).class).to be(Hijack::Page)
      expect((c = p.checksum).kind_of?(String)).to be(true)
      expect(c.empty?).to be(false)
      expect(checksums.include?(c)).to be(false)
      checksums << c
      #
      # if I do it twice it should tell me that the page is replicated
      #
      expect((p2 = Hijack::Page.new(uri)).class).to be(Hijack::Page)
      expect((c2 = p.checksum).kind_of?(String)).to be(true)
      expect(c2).to eq(c)
      expect(checksums.include?(c2)).to be(true)
    end
  end

# #
# # the +build_tree+ method is potentially bloating so we run it for a small website only
# #
# it 'builds the tree for each page' do
#   ruri = 'http://www.scelsi.it'
#   expect((p = Hijack::Page.new(ruri)).class).to be(Hijack::Page)
#   expect(p.html_content.nil?).to be(false)
#   expect(p.children.empty?).to be(true)
#   p.build_tree
#   expect(p.children.empty?).to be(false)
# end

end