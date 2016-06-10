require 'active_record'

module Hijack

  module OutputDrivers

    module Radiant

      class NoHijackedPageProvided < ArgumentError
        def message
          'must provide an original hijacked page in options[:hijacked_page]'
        end
      end

      class Base < ::ActiveRecord::Base

        self.abstract_class = true # this is still a base class for Radiant models
        self.logger = Hijack::Log

        attr_accessor :hijacked_page

        before_validation :initialize_properties

      private

        def initialize_properties
          attrs = self.attributes
          raise NoHijackedPageProvided unless attrs.has_key?('hijacked_page') && attrs['hijacked_page']
          self.hijacked_page = attrs.delete('hijacked_page')
        end

      end

    end

  end

end
