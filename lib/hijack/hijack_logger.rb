require 'logger'

module Hijack

  #
  # +Hijack::Logger+
  #
  # is a child of the +Logger+ class that is supposed to be a singleton within
  # +Hijack+.
  #
  # As such, only one instance is created here with a constant name +Log+
  # accessible from everywhere.
  #
  class Logger < ::Logger
  
    private_class_method :new
  
    LOGDIR = File.expand_path(File.join(['..'] * 3, 'log'), __FILE__)
    LOGFILE = File.join(LOGDIR, 'hijack.log')
  
    def initialize(logfile = LOGFILE)
      super(logfile)
    end
  
  end
  
  Log = Hijack::Logger.send(:new)

end
