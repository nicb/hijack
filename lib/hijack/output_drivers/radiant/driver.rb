module Hijack

  class Page; end

  module OutputDrivers

    module Radiant

      class Driver

        #
        # +PAGES_INDEX_START+ is the index number from which sqlite starts
        # indexing pages (we start from 2 because page n.1, the index
        # page, is loaded by hand)
        #
        PAGES_INDEX_START = 1

        def initialize
          seed_database
          install_page_methods
        end
  
        def output(pl)
          pl.pages.each { |p| p.radiant_output }
        end

      private

        def install_page_methods
          Hijack::Page.include PageMethods
        end

        def seed_database
          Hijack::OutputDrivers::Radiant::Base.connection.execute("UPDATE SQLITE_SEQUENCE SET seq = #{PAGES_INDEX_START} WHERE name = 'pages'")
        end
  
      end

    end

  end

end
