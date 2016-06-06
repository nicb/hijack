module Hijack

  class Website
    attr_reader :configuration_file
    attr_accessor :configuration, :page_loader, :driver

    def initialize(cf = Hijack::DEFAULT_CONFIG_FILE)
      self.configuration_file = cf
    end

    def process
      boot
      self.page_loader.suck
      self.driver.output(self.page_loader)
    end

    def configuration_file=(file)
      @configuration_file = file
      load @configuration_file
      @configuration = Hijack::Config
    end

  private

    def boot
      @page_loader = PageLoader.new(self.configuration.root_url, self.configuration.base_url)
      @driver = self.configuration.driver
    end

  end

end
