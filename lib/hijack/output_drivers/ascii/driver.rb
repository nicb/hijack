module Hijack

  class Page; end

  module OutputDrivers

    module Ascii

      class Driver

        attr_reader :file_handle
  
        def initialize(fh = STDOUT)
          @file_handle = fh
          install_page_methods
        end
  
        def output(pl)
          pl.pages.each { |p| p.ascii_output(self.file_handle) }
        end

      private

        def install_page_methods
          Hijack::Page.send(:define_method, :ascii_output) do
            |file_handle|
            file_handle.puts "%s: %s" % [self.uri, self.title]
          end
        end

      end

    end

  end

end
