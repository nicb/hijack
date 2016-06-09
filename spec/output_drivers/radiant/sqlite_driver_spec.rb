require 'spec_helper'

describe Hijack::OutputDrivers::Radiant::Sqlite::Driver do

  before :example do
    @google_url = 'https://www.google.com'
    @scelsi_base = 'http://www.scelsi.it'
    @scelsi_url = 'fondazione.php'
  end

  it 'can create itself' do
    expect((Hijack::OutputDrivers::Radiant::Sqlite::Driver.new).class).to be(Hijack::OutputDrivers::Radiant::Sqlite::Driver)
  end

  it 'does create a Page#radiant_output method' do
    expect((Hijack::OutputDrivers::Radiant::Sqlite::Driver.new).class).to be(Hijack::OutputDrivers::Radiant::Sqlite::Driver)
    expect(Hijack::Page.new(@google_url).respond_to?(:radiant_output)).to be(true)
  end

  it 'can be created with a specific file' do
    outfile = StringIO.new
    expect((Hijack::OutputDrivers::Radiant::Sqlite::Driver.new(outfile)).class).to be(Hijack::OutputDrivers::Radiant::Sqlite::Driver)
  end

  it 'does output Sqlite sql code' do
    outfile = StringIO.new
    Hijack::Config.title_tag = 'h1.home-claim'
    expect((Hijack::OutputDrivers::Radiant::Sqlite::Driver.new(outfile)).class).to be(Hijack::OutputDrivers::Radiant::Sqlite::Driver)
    expect((p = Hijack::Page.new(@scelsi_url, @scelsi_base)).respond_to?(:radiant_output)).to be(true)
    p.radiant_output(outfile)
    expect(outfile.size).to be > 0
    outfile.rewind
    expect(outfile.gets).to match(/INSERT INTO.*'#{p.title}'/)
  end

end

