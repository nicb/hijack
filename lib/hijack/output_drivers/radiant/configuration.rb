module Hijack

  module OutputDrivers

    module Radiant

      DEFAULT_CONFIGURATION_PARAMETERS =
      {
        :path => File.join(Hijack::ROOT_DIR, 'tmp', 'assets'),
        :storage => 'filesystem',
        :download_path => File.join(Hijack::ROOT_DIR, 'tmp', 'downloads')
      }

      class Configuration < Hijack::Configuration

        create_accessors(DEFAULT_CONFIGURATION_PARAMETERS)

      end

      Config = Configuration.send(:new)
      Config.load_defaults(DEFAULT_CONFIGURATION_PARAMETERS)

    end

  end

end
