require 'active_record'

module Hijack

  module OutputDrivers

    module Radiant

      class Base < ::ActiveRecord::Base

        before_validation :condition_attributes

        class << self

          def env
            ENV['HIJACK_ENV'] ||= 'development'
          end

        end

        establish_connection YAML.load_file(Hijack::DATABASE_CONFIGURATION_FILE)[env]

        self.abstract_class = true # this is still a base class for Hijack::OutputDrivers::Radiant models
        self.logger = Hijack::Log

      private
      
        def condition_attributes
          # by default does not do anything, successefully
        end

      end

    end

  end

end
