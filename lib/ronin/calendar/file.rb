require 'ronin/calendar/item'
require 'ronin/calendar/path'
require 'ronin/logging'


module Ronin


  class Calendar


    class File


      include Logging

      attr_reader :file, :contents

      def initialize(file=nil)
        
        # preferred CalendarFile is the first in the ordered list of valid files.
        @file=Calendar::File.PreferredFiles(file).first
        @contents=Calendar::File.Read(@file)

      end


      # TODO this currently only returns values not logging failures.  
      def self.PreferredFiles(file=nil)

        # The calendar files are called 'calendar' and reside in one of a few paths.
        files = CalendarPath.Preferred(file)
        files.collect!{ |dir| "#{dir}/calendar" }
        files.push( "/etc/calendar/default" )

        # Make sure the preferred files are files and exist.
        # TODO reverr the name of the class to File and uise ::File here to use the original meaning. 
        return files.reject { |f| ::File.directory?(f) || !::File.exist?(f) }
      end


      def self.Read(file)

        contents = []
        #logger.debug( "Reading #{file}" )
        begin
          # This is tedious and probably not a good idea given the number of exceptions 
          ::File.open(file, "r") do |infile|
            while( line = infile.gets )
              contents.push( Calendar::Item.Parse( line ) )
            end
          end
        rescue => err
          puts "#{err}"
          # TODO add a class property for the last error.
          #logger.error( "Error reading #{file}: #{err}" )
        end

        return contents

      end


      def write
      end


      def events
        return @contents.reject { |i| !i.respond_to?(:date) }
      end


      def to_s
        return @contents.collect {|c| "#{c}" }.join("\n")
      end

    end

  end

end
