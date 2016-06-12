require 'spec_helper'

describe Hijack::OutputDrivers::Radiant::Driver do

  before :example do
    @google_url = 'https://www.google.com'
    @scelsi_base = 'http://www.scelsi.it'
    @scelsi_url = 'fondazione.php'
  end

  it 'can create itself' do
    expect((Hijack::OutputDrivers::Radiant::Driver.new).class).to be(Hijack::OutputDrivers::Radiant::Driver)
  end

  it 'does create a Page#radiant_output method' do
    expect((Hijack::OutputDrivers::Radiant::Driver.new).class).to be(Hijack::OutputDrivers::Radiant::Driver)
    expect(Hijack::Page.new(@google_url).respond_to?(:radiant_output)).to be(true)
  end

end

