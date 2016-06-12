require 'spec_helper'

describe Hijack::OutputDrivers::Radiant::Page do

  before :example do
    require_relative File.join(['..'] * 3, 'config', 'configuration')
    @scelsi_base = 'http://www.scelsi.it'
    @scelsi_url = 'fondazione.php'
    @page = Hijack::Page.new(@scelsi_url, @scelsi_base)
  end

  it 'can be created with just a Hijack::Page#title argument' do
    expect(@page.class).to be(Hijack::Page)
    expect(@page.title.blank?).to be(false), "\"#{@page.title}\""
    expect(File.exists?(Hijack::OutputDrivers::Radiant::Base.connection_config[:database])).to be(true)
    expect((rp = Hijack::OutputDrivers::Radiant::Page.new(title: @page.title)).class).to be(Hijack::OutputDrivers::Radiant::Page)
    expect(rp.valid?).to be(true), rp.errors.full_messages.join(', ')
  end

  it 'can be created with just a Hijack::Page#title argument and all other attributes will follow suit' do
    expect(@page.class).to be(Hijack::Page)
    expect(@page.title.blank?).to be(false), "\"#{@page.title}\""
    expect(File.exists?(Hijack::OutputDrivers::Radiant::Base.connection_config[:database])).to be(true)
    expect((rp = Hijack::OutputDrivers::Radiant::Page.new(title: @page.title)).class).to be(Hijack::OutputDrivers::Radiant::Page)
    expect(rp.valid?).to be(true), rp.errors.full_messages.join(', ')
    fo = Hijack::OutputDrivers::Radiant::Page::CONDITIONAL_FALLBACK_OPTIONS
    fo.update(Hijack::OutputDrivers::Radiant::Page::MANDATORY_SETUP_OPTIONS)
    attrs_to_be_deleted = [ :title, :slug, :breadcrumb ]
    attrs_to_be_deleted.each { |a| fo.delete(a) }
    fo.each { |k, v| expect(rp.send(k)).to eq(v), "#{k}: #{rp.send(k)} != #{v}" }
  end

end
