#
# This is required by Arel
#
require 'active_record'
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

module Hijack

  class Page; end

  module OutputDrivers

    module Radiant

      module Sqlite

        class Driver
  
          attr_reader :file_handle
    
          def initialize(fh = STDOUT)
            @file_handle = fh
            Arel::Table.engine = ActiveRecord::Base
            install_page_methods
          end
    
          def output(pl)
            pl.pages.each { |p| p.radiant_output(self.file_handle) }
          end
  
        private
  
          def install_page_methods
            Hijack::Page.send(:define_method, :radiant_output) do
              |file_handle|
              rp = Hijack::OutputDrivers::Radiant::Page.new(hijacked_page: self)
              file_handle.puts rp.to_sql
            end
          end
  
        end

      end

    end

  end

end

