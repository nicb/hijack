require 'hijack'

#
# These are the configuration options for the +radiant+ output driver.
# They get loaded at runtime by the +Website+ object.
#

Hijack::OutputDrivers::Radiant::Config.configure do
  |conf|

  #
  # +paperclip.path+
  #
  # paperclip saves its processed images here
  #
  conf.path = File.join(Hijack::HIJACK_ROOT, 'tmp', 'assets')

  #
  # +paperclip.storage+
  #
  # paperclip storage type
  #
  conf.storage = 'filesystem'

  #
  # +hijack.download_path+
  #
  # +Hijack+ downloads assets here while hijacking
  #
  conf.download_path = File.join(Hijack::HIJACK_ROOT, 'tmp', 'downloads')

end
