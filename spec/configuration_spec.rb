require 'spec_helper'

describe Hijack::Configuration do

  it 'exists as a singleton' do
    expect(Hijack::Config.class).to be(Hijack::Configuration)
  end

  it 'can\'t exist otherwise' do
    expect { Hijack::Configuration.new }.to raise_error(NoMethodError)
  end

  it 'has default parameters' do
    Hijack::DEFAULT_CONFIGURATION_PARAMETERS.each do
      |k, v|
      expect(Hijack::Config.respond_to?(k)).to be(true)
      expect(Hijack::Config.send(k)).to eq(v)
    end
  end

  it 'can set parameters' do
    Hijack::DEFAULT_CONFIGURATION_PARAMETERS.each do
      |k, v|
      write_method = k.to_s + '='
      expect(Hijack::Config.respond_to?(write_method)).to be(true)
      value = Forgery(:basic).text
      Hijack::Config.send(write_method, value)
      expect(Hijack::Config.send(k)).to eq(value)
    end
  end

  it 'can work as a configuration dsl' do
    new_config = {}
    Hijack::DEFAULT_CONFIGURATION_PARAMETERS.keys.each do
      |k|
      new_config.update(k => Forgery(:basic).text)
    end
    new_config.each do
      |k, v|
      write_method = k.to_s + '='
      Hijack::Config.configure do
        |conf|
        expect(conf.respond_to?(write_method)).to be(true)
        conf.send(write_method, v)
      end
      expect(Hijack::Config.send(k)).to eq(v)
    end
  end

end
