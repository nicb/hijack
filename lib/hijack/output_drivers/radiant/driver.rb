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
          Hijack::Page.send(:define_method, :radiant_output) do
            rp = Hijack::OutputDrivers::Radiant::Page.create(title: self.title)
          end
        end
  
      end

    end

  end

end
