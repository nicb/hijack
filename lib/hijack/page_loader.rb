module Hijack

  class PageLoader
    attr_reader :base_path, :root, :pages, :visited_links

    def initialize(r = 'index.html', b = 'http://www.example.com')
      @base_path = b
      @root = r
      @pages = []
    end

    #
    # <tt>suck(limit = nil)</tt>
    #
    # sucks up an entire website, or up to +limit+ pages.
    #
    def suck(limit = nil)
      start = full_uri(self.root)
      self.pages << Page.new(start, self.base_path)
      inner_suck(self.pages.first, limit)
    end

    def visited_links
      self.pages.map { |p| p.uri }
    end

    def find_page(l)
      idx = self.visited_links.index(l)
      self.pages[idx] if idx
    end

  private

    def inner_suck(p, limit)
      return if enough?(limit)
      p.links.each do
        |l|
        vl = full_uri(l)
        begin
          if (fp = self.find_page(vl))
            fp.linked_from << p
          else
            np =  Page.new(vl, self.base_path)
            np.linked_from << p
            self.pages << np
            return if enough?(limit)
            inner_suck(np, limit)
          end
        rescue OpenURI::HTTPError, URI::InvalidURIError => e
          Hijack::Log.warn(vl + ': ' + e.message)
        end
      end
    end

    def full_uri(l)
      [self.base_path, l].join('/')
    end

    def enough?(limit)
      limit && self.pages.size >= limit
    end

  end

end
