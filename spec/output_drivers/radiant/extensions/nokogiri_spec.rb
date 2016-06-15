require 'spec_helper'

describe 'Hijack::OutputDrivers::Radiant::Extensions::Nokogiri' do

  before :example do
    require File.join(Hijack::ROOT_DIR, 'config', 'configuration')
    @url = 'archivio_attivita.php'
    @base = 'http://www.scelsi.it'
    @page = Hijack::Page.new(@url, @base)
  end

  it 'adds the to_radiant method to Nokogiri::XML::Elements' do
    expect(@page.html_content.elements.first.respond_to?(:to_radiant)).to be(true)
  end

  it 'adds the to_radiant method to Nokogiri::XML::NodeSet' do
    expect((ns = Nokogiri::XML::NodeSet.new(@page.html_content)).class).to be(Nokogiri::XML::NodeSet)
    expect(ns.respond_to?(:to_radiant)).to be(true)
  end

  it 'can convert a full document to radiant (with radiant tags)' do
    tag_matches = [ '<r:assets:image', '<r:link', '<div', '<h1', '<p' ]
    text_matches =
    [
      'L&rsquo;Archivio Scelsi conserva il lascito artistico e culturale del Maestro e raccoglie documenti',
      'Direzione Generale per gli Archivi;',
      'Giancarlo Schiaffini',
      'VISUALIZZA L',
      'il ciclo di incontri &quot;Appunti d&rsquo;Archivio&quot;, a cura di Alessandra Carlotta Pellegrini',
    ]
    tag_matches.each { |m| expect(@page.html_content.css(Hijack::Config.content_tag).to_radiant).to match(/#{m}/), "\"#{m}\" does not match" }
    text_matches.each { |m| expect(@page.html_content.css(Hijack::Config.content_tag).to_radiant).to match(/#{m}/), "\"#{m}\" does not match" }
  end

end
