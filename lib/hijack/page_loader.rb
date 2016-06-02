module Hijack

  class PageLoader
    attr_reader :base_path, :root

    def initialize(r = 'index.html', b = '.')
      @base = '.'
      @root = r
    end

    def suck
    end

  end

end
