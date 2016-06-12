module RSpec

  module Support

    module Configuration

      def create_empty_configuration
        create_configuration do
          |conffh, uurl|
          conffh.write <<-EOF
            Hijack::Config.configure do
            end
          EOF
        end
      end
    
      def create_mock_configuration
        url = "http://#{Forgery(:internet).domain_name}"
        create_configuration(url) do
          |conffh, uurl|
          conffh.write <<-EOF
            Hijack::Config.configure do
              |conf|
              conf.base_url = '#{uurl}'
            end
          EOF
        end
      end
    
      def create_stringio_configuration(url, root)
        create_configuration(url) do
          |conffh, uurl|
          conffh.write <<-EOF
            Hijack::Config.configure do
              |conf|
              conf.driver = Hijack::OutputDrivers::Ascii::Driver.new(StringIO.new)
              conf.base_url = '#{uurl}'
              conf.root_url = '#{root}'
            end
          EOF
        end
      end

      def create_radiant_configuration(url, root)
        create_configuration(url) do
          |conffh, uurl|
          conffh.write <<-EOF
            Hijack::Config.configure do
              |conf|
              conf.driver = Hijack::OutputDrivers::Radiant::Driver.new
              conf.base_url = '#{uurl}'
              conf.root_url = '#{root}'
            end
          EOF
        end
      end

    private

      def create_configuration(url = Hijack::Configuration::DEFAULT_CONFIGURATION_PARAMETERS[:base_url])
        Hijack::Config.send(:load_defaults)
        conff = Tempfile.new('conf', Hijack::TMPDIR)
        yield(conff, url)
        conff.flush
        conff.close
        [conff.path, url]
      end

    end

  end

end
