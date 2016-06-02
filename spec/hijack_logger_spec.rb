require 'spec_helper'

describe Hijack::Logger do

  TEMPDIR = File.expand_path(File.join(['..'] * 2, 'tmp'), __FILE__)

  before :example do
    @logfile = Tempfile.new('test', TEMPDIR)
  end

  after :example do
    @logfile.close!
  end

  it 'is a singleton and it cannot be created' do
    expect { Hijack::Logger.new }.to raise_error(NoMethodError)
  end

  it 'has an only singleton copy that can be used' do
    expect(defined?(Hijack::Log)).to eq('constant')
  end

  it 'actually even works' do
    expect((l = Hijack::Logger.send(:new, @logfile)).class).to be(Hijack::Logger)
    expect(File.exists?(@logfile)).to be(true)
    l.debug('this is a log message')
    @logfile.flush
    expect(File.size(@logfile)).to be > 0
  end

end
