require 'nokogiri'
require 'open-uri'
require 'digest'

module Hijack

  class Page
    attr_reader :uri, :base, :html_content, :checksum, :linked_from

    def initialize(u, p = nil)
      @uri = u
      @base = p ? p.base : u
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
    MANDATORY_EXCLUDES = [ 'index.php', 'index.html', '#' ] # avoid links back to root nodes and empty labels

    def links(exclude = [])
      #
      # avoid recursions at all costs
      #
      links_on_page - MANDATORY_EXCLUDES - [ self.uri ] - exclude
    end

#     links_to_visit.each do
#       |l|
#       begin
#         p = Page.new(l, self)
#         p.build_tree
#         self.children << p
#       rescue URI::InvalidURIError => msg
#         # log.warn(msg)
#       end
#     end
#     self.children
#   end

  private

    def suck
      Nokogiri::HTML(open(normalized_uri)) { |config| config.noblanks }
    end

    PROTO_REGEXP = Regexp.compile(/\A(http:\/\/|https:\/\/|ftp:\/\/)/)

    def normalized_uri
      res = self.uri
      res = [self.base, self.uri].join('/') unless self.uri =~ PROTO_REGEXP
      res
    end

    def stripped_uri
      res = ''
      suri = self.uri.sub(PROTO_REGEXP, '')
      p = suri.index('/')
      #
      # if p is nil or p is at EOS it means that either the uri ends with a
      # slash or it has no slash and no following link so we should simply
      # return an empty string
      #
      if p && p != (self.uri.size - 1)
        res = suri[p+1..-1]
      end
      res
    end

    def calculate_checksum
      Digest::MD5.hexdigest(self.html_content.to_s)
    end

    def links_on_page
      self.html_content.css('a').map { |aref| aref.attributes['href'].value }.uniq
    end

  end

end
