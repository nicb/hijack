module Hijack

  module OutputDrivers

    module Radiant

      #
      # the +PageMethods+ module is to be included from the +Hijack::Page+
      # object to provide all the necessary methods to produce the appropriate
      # output
      #
      module PageMethods

        #
        # +radiant_output+
        #
        # is actually the main hook for the +Radiant::Driver+ into the pages
        # hijacked
        #
        def radiant_output
          create_radiant_pages
        end

      private

        def create_radiant_pages
          begin
            rp = Hijack::OutputDrivers::Radiant::Page.create!(title: self.title)
            #
            # we have to wait for the record to be persisted
            # 
            rp.ready?
            rp.page_parts.create(name: 'body', content: self.content)
            rp.page_parts.create(name: 'extended', content: '')
            rp.page_fields.create(name: 'Keywords', content: '')
            rp.page_fields.create(name: 'Description', content: self.page_title)
          rescue ActiveRecord::RecordInvalid => e
            Hijack::Log.warn("Invalid record #{self.base}/#{self.uri} skipped: #{e.message}")
          end
        end

      end

    end

  end

end
