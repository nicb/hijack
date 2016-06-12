require 'spec_helper'
require_relative 'support/configuration'

include RSpec::Support::Configuration

describe Hijack::Website do

  before :example do
    @remote_uris =
    {
       'http://www.scelsi.it' => 'Fondazione Isabella Scelsi',
    }
  end

  it 'can be created without arguments' do
    @remote_uris.keys.each do
      |uri|
      expect((w = Hijack::Website.new).class).to be(Hijack::Website)
      expect(w.configuration_file).to eq(Hijack::DEFAULT_CONFIG_FILE)
      expect(w.configuration).to eq(Hijack::Config)
    end
  end

  it 'can be created with an empty configuration' do
    (tmpfile, url) = create_empty_configuration
    @remote_uris.keys.each do
      |uri|
      expect((w = Hijack::Website.new(tmpfile)).class).to be(Hijack::Website)
      expect(w.configuration_file).to eq(tmpfile)
      expect(w.configuration).to eq(Hijack::Config)
      expect(w.configuration.base_url).to eq(Hijack::Configuration::DEFAULT_CONFIGURATION_PARAMETERS[:base_url])
    end
  end

  it 'can be created with one argument' do
    (tmpfile, url) = create_mock_configuration
    @remote_uris.keys.each do
      |uri|
      expect((w = Hijack::Website.new(tmpfile)).class).to be(Hijack::Website)
      expect(w.configuration_file).to eq(tmpfile)
      expect(w.configuration).to eq(Hijack::Config)
      expect(w.configuration.base_url).to eq(url)
    end
  end

  it 'can change configuration file on the fly' do
    (tmpfile, url) = create_mock_configuration
    @remote_uris.keys.each do
      |uri|
      expect((w = Hijack::Website.new).class).to be(Hijack::Website)
      w.configuration_file = tmpfile
      expect(w.configuration_file).to eq(tmpfile)
      expect(w.configuration).to eq(Hijack::Config)
      expect(w.configuration.base_url).to eq(url)
    end
  end

  it 'can suck up an entire website and render it in ascii', :slow => true do
    (tmpfile, url) = create_stringio_configuration(@remote_uris.keys.first, 'index.php')
    @remote_uris.keys.each do
      |uri|
      expect((w = Hijack::Website.new).class).to be(Hijack::Website)
      w.configuration_file = tmpfile
      expect(w.configuration.base_url).to eq(uri)
      w.process
      expect((out = w.driver.file_handle).kind_of?(StringIO)).to be(true)
      expect(out.size).to be > 1000
    end
  end

  it 'can suck up an entire website and render it as radiant sql pages', :slow => true do
    (tmpfile, url) = create_radiant_configuration(@remote_uris.keys.first, 'index.php')
    expected_min_n_of_pages = 75
    @remote_uris.keys.each do
      |uri|
      expect((w = Hijack::Website.new).class).to be(Hijack::Website)
      w.configuration_file = tmpfile
      expect(w.configuration.base_url).to eq(uri)
      w.process
      expect(Hijack::OutputDrivers::Radiant::Page.count).to be > expected_min_n_of_pages, "page count: #{Hijack::OutputDrivers::Radiant::Page.count} <= #{expected_min_n_of_pages}"
    end
  end

end
