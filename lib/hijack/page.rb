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
    # +title+
    #
    # it returns the title of the current page (simply delegating `Nokogiri` to do
    # it)
    #
    def title
      self.html_content.title
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
        m_e << lop unless same_base?(lop, self.base)
      end
      m_e = m_e.compact.uniq
    end

  end

end
