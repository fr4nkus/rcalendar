require 'ronin/calendar/config'
require 'ronin/calendar/file'
require 'ronin/logging'

=begin

Calendar is a really nice little Unix command that displays events 
for the next few days. This is populated with holidays for locals and
religions, but a user can also use calendat ro record their own anniversaries
and events.

This application attempts to retrieve google calendar events and insert them
into the calendar files (this can be done in the background by cron or at)

=end 

module Ronin


  # TODO Need a shared singleton to define the date used so we can test.


  class Calendar


    attr_reader :config , :file

    include Logging


    def initialize(options={})
      #logger.debug( "Initializing Calendar" )
      @config = Ronin::Calendar::Config.new( options[:path] )
      @file = Ronin::Calendar::File.new( options[:file] )
    end


    def to_s
      return @file.to_s
    end


    def events  (options={})

      events = @file.events
      events.sort! { |a,b| a.date <=> b.date }

      return events if options.empty?

      from=options[:from] || nil
      unless from.nil?
        events.reject! { |e| e.date.jd < from.jd }
      end

      till=options[:till] || nil
      unless till.nil?
        events.reject! { |e| e.date.jd > till.jd }
      end

      limit=options[:limit] || nil
      return events[0..limit] unless limit.nil?

    end


  end


end
