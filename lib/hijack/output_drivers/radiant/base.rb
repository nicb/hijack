require 'arel'
require 'active_support/core_ext/string'

module Hijack

  module OutputDrivers

    module Radiant

      class NoHijackedPageProvided < ArgumentError
        def message
          'must provide an original hijacked page in options[:hijacked_page]'
        end
      end

      class Base
        attr_accessor :hijacked_page
        attr_reader   :properties
        attr_reader   :arel_table, :arel_manager

        def initialize(args = {})
          initialize_properties(args)
        end

        def to_sql
          (a_t, a_m) = self.class.arel
          sql_array = prepare_sql_array(a_t)
          a_m.insert(sql_array)
          a_m.to_sql
        end

        #
        # <tt>prepare_sql_array(table)</tt>
        #
        # this method is supposed to prepare the appropriate sql array for
        # each sub-object. It does nothing in the base class.
        #
        def prepare_sql_array(table)
          []
        end

        class << self

          def arel
            table_name = self.name.demodulize.underscore.pluralize.to_sym
            arel_table = Arel::Table.new(table_name, ActiveRecord::Base)
            arel_manager = Arel::InsertManager.new(ActiveRecord::Base)
            [arel_table, arel_manager]
          end

        end

      protected

        def initialize_properties(attrs)
          attrs.stringify_keys!
          raise NoHijackedPageProvided unless attrs.has_key?('hijacked_page') && attrs['hijacked_page']
          self.hijacked_page = attrs.delete('hijacked_page')
          @properties = attrs
        end

      end

    end

  end

end
