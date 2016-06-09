require 'hijack'

#
# Configuration options are all contained in the +config/configuration.rb+
# file. They get loaded at runtime by the +Website+ object.
#

Hijack::Config.configure do
  |conf|

  #
  # +base_url+: set the base url where to start from
  #
  conf.base_url = 'http://www.scelsi.it'
  #
  # +root_url+ is the starting page
  #
  conf.root_url = 'index.php'
  #
  # +title_tag+ set the tag(s) which hold the title
  #
  conf.title_tag = 'h1.home-claim'
  #
  # +content_tag+ set the tag(s) which hold the content
  #
  conf.content_tag = 'div.uk-width-medium-3-4'
  #
  # +image_tags+ set the tag(s) which should return image links
  #
  conf.image_tags = "#{conf.content_tag}>div.uk-thumbnail"
  #
  # +driver+
  #
  conf.driver = Hijack::OutputDrivers::Radiant::Sqlite::Driver.new

end

