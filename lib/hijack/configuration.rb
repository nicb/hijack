module Hijack

  #
  # +Configuration+ is a singleton class which has
  # a single instance pre-declared here
  #
  class Configuration
    attr_accessor :base_url, :root_url, :driver, :title_tag, :content_tag

    private_class_method :new

    DEFAULT_CONFIGURATION_PARAMETERS =
    {
       :base_url => 'http://www.example.com',
       :root_url => 'index.html',
       :driver   => Hijack::OutputDrivers::Ascii::Driver.new,
       :title_tag => 'div.title',
       :content_tag => 'div.content',
    }

    def initialize
      DEFAULT_CONFIGURATION_PARAMETERS.each do
        |k, v|
        meth = k.to_s + '='
        self.send(meth, v)
      end
    end

    def configure
      yield(self)
    end

  end

  Config = Configuration.send(:new)

end
