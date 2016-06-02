module Hijack

  class Website
    attr :page_loader, :driver

    def initialize
      @page_loader = PageLoader.new(Config.root_url, Config.base_url)
      @driver = Config.driver
    end

    def process
      self.page_loader.suck
      self.driver.output(self.page_loader)
    end

  end

end
