require 'arel'
require 'active_support/core_ext/date_time'

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

        has_many :page_parts
        has_many :page_fields

        before_validation :set_fallback_backdrop

#       attr_accessor :title, :slug, :breadcrumb, :class_name, :status_id, :parent_id, :layout_id,
#                     :created_at, :updated_at, :published_at,
#                     :created_by_id, :updated_by_id,
#                     :virtual, :lock_version, :allowed_children_cache
#       attr_reader   :arel_table, :arel_manager

        FALLBACK_OPTIONS =
        {
           hijacked_page: nil,
           title: 'No Title', slug: '/', breadcrumb: 'No Title', class_name: '', status_id: 100,
           parent_id: nil, layout_id: 2, created_by_id: 1, updated_by_id: nil, virtual: 'f', lock_version: 0,
           allowed_children_cache: 'Page,ArchiveDayIndexPage,ArchiveMonthIndexPage,ArchivePage,ArchiveYearIndexPage,EnvDumpPage,FileNotFoundPage,JavascriptPage,StylesheetPage',
        }



        def initialize(options = {})
          opts = FALLBACK_OPTIONS
          opts.update(options)
          super(opts)
        end

        def prepare_sql_array(arel_table)
          sql_array = []
          @properties['title'] = @properties['breadcrumb'] = self.hijacked_page.title
          @properties['slug'] = self.hijacked_page.title.downcase.gsub(/\W+/, '-')
          @properties.each { |k, v| sql_array << [ arel_table[k], v ] }
          sql_array
        end

      private

        def initialize_properties(attrs)
          super
          now = Time.now.to_s(:db)
          @properties['created_at'] = @properties['updated_at'] = @properties['published_at'] = now
          @properties
        end

      end

    end

  end

end
