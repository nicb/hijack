require 'spec_helper'

describe Hijack::Page do

  before :example do
    @remote_uris =
    {
       'http://www.scelsi.it' => 'Fondazione Isabella Scelsi',
       'https://www.w3.org' => 'World Wide Web Consortium (W3C)',
    }
    @f_base = 'http://www.scelsi.it'
    @f_page = 'archivio_attivita.php'
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
      expect(p.page_title).to eq(title)
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

  it 'returns the images tags to images' do
    load_configuration
    expect((p = Hijack::Page.new(@f_page, @f_base)).class).to be(Hijack::Page)
    expect(p.image_tags.size).to eq(1)
    p.image_tags.each { |it| expect(it.to_html).to match(/<img.*src=.*>/) }
  end

  it 'returns the links to other pages' do
    load_configuration
    expect((p = Hijack::Page.new(@f_page, @f_base)).class).to be(Hijack::Page)
    expect(p.link_tags.size).to eq(1)
    p.link_tags.each { |lt| expect(lt.to_html).to match(/<a.*href=.*\/a>/) }
  end

  it 'returns the content as Nokogiri::XML::NodeSet' do
    load_configuration
    expect((p = Hijack::Page.new(@f_page, @f_base)).class).to be(Hijack::Page)
    expect(p.content.class).to be(Nokogiri::XML::NodeSet)
  end

private

  def load_configuration
    require File.join(Hijack::ROOT_DIR, 'config', 'configuration')
  end

end
