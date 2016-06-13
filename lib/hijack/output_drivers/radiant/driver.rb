module Hijack

  class Page; end

  module OutputDrivers

    module Radiant

      class Driver

        def initialize
          install_page_methods
        end
  
        def output(pl)
          pl.pages.each { |p| p.radiant_output }
        end

      private

        def install_page_methods
          Hijack::Page.include PageMethods
        end
  
      end

    end

  end

end
