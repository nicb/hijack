require 'spec_helper'

describe Hijack::OutputDrivers::Radiant::Configuration do

  it 'exists as a singleton' do
    expect(Hijack::OutputDrivers::Radiant::Config.class).to be(Hijack::OutputDrivers::Radiant::Configuration)
  end

  it 'can\'t exist otherwise' do
    expect { Hijack::OutputDrivers::Radiant::Configuration.new }.to raise_error(NoMethodError)
  end

  it 'responds read/write to configuration accessors' do
    Hijack::OutputDrivers::Radiant::DEFAULT_CONFIGURATION_PARAMETERS.keys.each do
      |k|
      expect(Hijack::OutputDrivers::Radiant::Config.respond_to?(k)).to be(true)
      expect(Hijack::OutputDrivers::Radiant::Config.respond_to?(k.to_s + '=')).to be(true)
    end
  end

  it 'DOES NOT respond to Hijack configuration accessors' do
    Hijack::DEFAULT_CONFIGURATION_PARAMETERS.keys.each do
      |k|
      expect(Hijack::OutputDrivers::Radiant::Config.respond_to?(k)).to be(false)
      expect(Hijack::OutputDrivers::Radiant::Config.respond_to?(k.to_s + '=')).to be(false)
    end
  end

  it 'has default parameters' do
    Hijack::OutputDrivers::Radiant::DEFAULT_CONFIGURATION_PARAMETERS.each do
      |k, v|
      expect(Hijack::OutputDrivers::Radiant::Config.respond_to?(k)).to be(true)
      expect(Hijack::OutputDrivers::Radiant::Config.send(k)).to eq(v)
    end
  end

  it 'can set parameters' do
    Hijack::OutputDrivers::Radiant::DEFAULT_CONFIGURATION_PARAMETERS.each do
      |k, v|
      write_method = k.to_s + '='
      expect(Hijack::OutputDrivers::Radiant::Config.respond_to?(write_method)).to be(true)
      value = Forgery(:basic).text
      Hijack::OutputDrivers::Radiant::Config.send(write_method, value)
      expect(Hijack::OutputDrivers::Radiant::Config.send(k)).to eq(value)
    end
  end

  it 'can work as a configuration dsl' do
    new_config = {}
    Hijack::OutputDrivers::Radiant::DEFAULT_CONFIGURATION_PARAMETERS.keys.each do
      |k|
      new_config.update(k => Forgery(:basic).text)
    end
    new_config.each do
      |k, v|
      write_method = k.to_s + '='
      Hijack::OutputDrivers::Radiant::Config.configure do
        |conf|
        expect(conf.respond_to?(write_method)).to be(true)
        conf.send(write_method, v)
      end
      expect(Hijack::OutputDrivers::Radiant::Config.send(k)).to eq(v)
    end
  end

end
