module Hijack

  module OutputDrivers

    module Radiant

      #
      # Page Create (1.1ms)   INSERT INTO "pages" ("title", "slug", "breadcrumb", "class_name", "status_id", "parent_id", "layout_id", "created_at", "updated_at", "published_at", "created_by_id", "updated_by_id", "virtual", "lock_version", "allowed_children_cache") VALUES('This is the title', '/', 'This is the title', '', 100, NULL, 1, '2016-06-08 21:57:09', '2016-06-08 21:57:09', '2016-06-08 21:57:08', 1, NULL, 'f', 0, 'Page,ArchiveDayIndexPage,ArchiveMonthIndexPage,ArchivePage,ArchiveYearIndexPage,EnvDumpPage,FileNotFoundPage,JavascriptPage,StylesheetPage')
      # PagePart Create (4.7ms)   INSERT INTO "page_parts" ("name", "filter_id", "content", "page_id") VALUES('body', '', '', 1)
      # PagePart Create (0.4ms)   INSERT INTO "page_parts" ("name", "filter_id", "content", "page_id") VALUES('extended', '', '', 1)
      # PageField Create (0.6ms)   INSERT INTO "page_fields" ("page_id", "name", "content") VALUES(1, 'Keywords', '')
      # PageField Create (0.4ms)   INSERT INTO "page_fields" ("page_id", "name", "content") VALUES(1, 'Description', '')
      #

      class Page < Base

        validates :title, presence: true

        has_many :page_parts
        has_many :page_fields

        CONDITIONAL_FALLBACK_OPTIONS = HashWithIndifferentAccess.new(
           title: 'No Title', slug: '/', breadcrumb: 'No Title', class_name: '', parent_id: nil,
        )

        MANDATORY_SETUP_OPTIONS = HashWithIndifferentAccess.new(
           status_id: 100, layout_id: 2, created_by_id: 1, updated_by_id: nil, virtual: false, lock_version: 0,
           allowed_children_cache: 'Page,ArchiveDayIndexPage,ArchiveMonthIndexPage,ArchivePage,ArchiveYearIndexPage,EnvDumpPage,FileNotFoundPage,JavascriptPage,StylesheetPage',
        )


      private

        def set_fallback_backdrop
          CONDITIONAL_FALLBACK_OPTIONS.each { |k, v| write_attribute(k, v) if read_attribute(k).blank? }
          MANDATORY_SETUP_OPTIONS.each { |k, v| write_attribute(k, v) }
        end

        def condition_attributes
          set_fallback_backdrop
          super
          write_attribute('breadcrumb', read_attribute('title'))
          write_attribute('slug', read_attribute('title').downcase.gsub(/\W+/, '-'))
          now = Time.now
          ['created_at', 'updated_at', 'published_at'].each { |k| write_attribute(k, now) }
        end

      end

    end

  end

end
