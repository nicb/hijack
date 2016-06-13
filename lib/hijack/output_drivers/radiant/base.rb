require 'active_record'

module Hijack

  module OutputDrivers

    module Radiant

      class RecordTimedOut < StandardError

        attr_reader :num_of_iterations

        def initialize(n)
          @num_of_iterations = n
        end

        def message
          "Record not ready after #{self.num_of_iterations} seconds: timed out"
        end

      end

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

        #
        # +ready?+
        #
        # this method holds the upper hand until the record is properly
        # persisted, so that we do not try to save sub-records too early
        #
        MAX_READY_ITERATIONS = 50
        def ready?
          res = false
          MAX_READY_ITERATIONS.times do
            if persisted?
              res = true
              break
            end
            sleep(1)
          end
          raise RecordTimedOut.new(MAX_READY_ITERATIONS) unless res
          res
        end

      private
      
        def condition_attributes
          # by default does not do anything, successefully
        end

      end

    end

  end

end
