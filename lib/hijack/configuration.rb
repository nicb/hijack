module Hijack

  module OutputDrivers
    module Ascii
      class Driver; end
    end
  end

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

  #
  # +Configuration+ is a singleton class which has
  # a single instance pre-declared here
  #
  class Configuration

    private_class_method :new

    class << self

      def create_accessors(parms)
        parms.keys.each { |k| attr_accessor k }
      end

      def destroy_accessors(parms)
        parms.keys.each do
          |k|
          undef_method k
          undef_method k.to_s + '='
        end
      end

      def inherited(subclass)
        subclass.destroy_accessors(DEFAULT_CONFIGURATION_PARAMETERS)
      end

    end

    create_accessors(DEFAULT_CONFIGURATION_PARAMETERS)

    def configure
      yield(self)
    end

    def load_defaults(parms)
      parms.each do
        |k, v|
        meth = k.to_s + '='
        self.send(meth, v)
      end
    end

  end

  Config = Configuration.send(:new)
  Config.load_defaults(DEFAULT_CONFIGURATION_PARAMETERS)

end
