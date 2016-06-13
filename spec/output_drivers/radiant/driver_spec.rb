require 'spec_helper'

describe Hijack::OutputDrivers::Radiant::Driver do

  before :example do
    @google_url = 'https://www.google.com'
    @scelsi_base = 'http://www.scelsi.it'
    @scelsi_url = 'fondazione.php'
    @num_of_page_parts = 2
  end

  it 'can create itself' do
    expect((Hijack::OutputDrivers::Radiant::Driver.new).class).to be(Hijack::OutputDrivers::Radiant::Driver)
  end

  it 'does create a Page#radiant_output method' do
    expect((Hijack::OutputDrivers::Radiant::Driver.new).class).to be(Hijack::OutputDrivers::Radiant::Driver)
    expect(Hijack::Page.new(@google_url).respond_to?(:radiant_output)).to be(true)
  end

  it 'creates radiant pages along with all its satellite records' do
    clear_pages_and_satellites
    require_relative File.join(['..'] * 3, 'config', 'configuration')
    expect((Hijack::OutputDrivers::Radiant::Driver.new).class).to be(Hijack::OutputDrivers::Radiant::Driver)
    expect((page = Hijack::Page.new(@scelsi_url, @scelsi_base)).class).to be(Hijack::Page)
    expect(page.respond_to?(:radiant_output)).to be(true)
    expect(page.title.blank?).to be(false), "\"#{page.title}\""
    expect(File.exists?(Hijack::OutputDrivers::Radiant::Base.connection_config[:database])).to be(true)
    page.radiant_output
    expect(Hijack::OutputDrivers::Radiant::Page.count).to eq(1)
    expect((rp = Hijack::OutputDrivers::Radiant::Page.first).class).to be(Hijack::OutputDrivers::Radiant::Page)
    expect(rp.valid?).to be(true), rp.errors.full_messages.join(', ')
    expect(rp.page_parts(true).count).to eq(@num_of_page_parts)
    expect(rp.page_fields(true).count).to eq(@num_of_page_parts)
    expect(rp.page_parts.where('name = ?', 'body').first.content).to eq(page.content)
  end

private

  def clear_pages_and_satellites
    [Hijack::OutputDrivers::Radiant::Page, Hijack::OutputDrivers::Radiant::PagePart, Hijack::OutputDrivers::Radiant::PageField].each { |k| k.destroy_all }
  end

end

