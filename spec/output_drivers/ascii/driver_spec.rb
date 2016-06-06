require 'spec_helper'

describe Hijack::OutputDrivers::Ascii::Driver do

  it 'can create itself' do
    expect((Hijack::OutputDrivers::Ascii::Driver.new).class).to be(Hijack::OutputDrivers::Ascii::Driver)
  end

  it 'can be created with a specific file' do
    outfile = StringIO.new
    expect((Hijack::OutputDrivers::Ascii::Driver.new(outfile)).class).to be(Hijack::OutputDrivers::Ascii::Driver)
  end

end
