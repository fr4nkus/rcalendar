module Logging

  require 'log4r'
  include Log4r

  def logger
    Logging.logger
  end

  def self.logger

    if @logger.nil?
      @logger = Logger.new 'rcalendar'
      @logger.outputters = Outputter.stdout
    end
  
    return @logger

  end

end
