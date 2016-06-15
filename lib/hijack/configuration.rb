module Hijack

  #
  # +Configuration+ is a singleton class which has
  # a single instance pre-declared here
  #
  class Configuration
    attr_accessor :base_url, :root_url, :driver, :title_tag, :content_tag, :image_tags, :link_tags

    private_class_method :new

    DEFAULT_CONFIGURATION_PARAMETERS =
    {
       :base_url => 'http://www.example.com',
       :root_url => 'index.html',
       :driver   => Hijack::OutputDrivers::Ascii::Driver.new,
       :title_tag => 'div.title',
       :content_tag => 'div.content',
       :image_tags => 'img',
       :link_tags => 'a',
    }

    def initialize
      load_defaults
    end

    def configure
      yield(self)
    end

  private

    def load_defaults
      DEFAULT_CONFIGURATION_PARAMETERS.each do
        |k, v|
        meth = k.to_s + '='
        self.send(meth, v)
      end
    end

  end

  Config = Configuration.send(:new)

end
