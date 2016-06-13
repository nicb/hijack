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
            rp = nil
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

end
