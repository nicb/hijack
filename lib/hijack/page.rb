require 'nokogiri'
require 'open-uri'
require 'digest'

module Hijack

  class Page
    attr_reader :uri, :base, :html_content, :checksum, :linked_from

    def initialize(u, p = nil)
      @uri = u
      @base = p ? p : u
      @html_content = suck
      @checksum = calculate_checksum
      @linked_from = []
    end

    #
    # +page_title+
    #
    # it returns the page title of the current page (simply delegating `Nokogiri` to do
    # it)
    #
    def page_title
      self.html_content.title
    end

    #
    # +title+
    #
    # it returns the actual title of the current page (simply delegating `Nokogiri` to do
    # it)
    #
    def title
      self.html_content.css(Hijack::Config.title_tag).text
    end

    #
    # +content+
    #
    # it returns the content of the current page (simply delegating `Nokogiri` to do
    # it) as a Nokogiri::XML::NodeSet. This will exclude the outer +div+
    # decoration
    #
    def content
      res = self.html_content.css(Hijack::Config.content_tag)
      res.children
    end

    #
    # +image_tags+
    #
    # it returns the Nokogiri structures that contain images in the current page
    #
    def image_tags
      self.html_content.css(Hijack::Config.content_tag).css(Hijack::Config.image_tags)
    end

    #
    # +link_tags+
    #
    # it returns the Nokogiri structures that contain links in the current page
    #
    def link_tags
      self.html_content.css(Hijack::Config.content_tag).css(Hijack::Config.link_tags)
    end

    #
    # +links(exclude = [])+
    #
    # builds the list of links for this page.
    #
    MANDATORY_EXCLUDES = Regexp.compile(/(index.php|index.html|#|mailto:)/) # avoid links back to root nodes and empty labels

    def links(exclude = [])
      links_on_page - excluded_uris(exclude)
    end

    #
    # +full_uri+
    #
    # return the absolute uri of the page
    #
    def full_uri
      normalize(self.uri, self.base)
    end

  private

    include Hijack::Helpers::URI

    def suck
      nuri = normalize(self.uri, self.base)
      Nokogiri::HTML(open(nuri)) { |config| config.noblanks }
    end

    def calculate_checksum
      Digest::MD5.hexdigest(self.html_content.to_s)
    end

    def links_on_page
      self.html_content.css('a').map do
        |aref|
        href = aref.attributes['href']
        href.value if href
      end.compact.uniq
    end

    #
    # avoid recursions at all costs
    #
    def excluded_uris(exclude)
      m_e = exclude
      links_on_page.each do
        |lop|
        if lop.match(MANDATORY_EXCLUDES)
          m_e << lop
          next
        end
        m_e << lop unless relative?(lop) || same_base?(lop, self.base)
      end
      m_e = m_e.compact.uniq
    end

  end

end
