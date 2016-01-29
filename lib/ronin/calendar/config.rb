#!/usr/bin/env ruby 

module Ronin

  class Calendar

    # This  class may only be required while the ccp isn't plugged in.
    class Config


      def initialize(file=nil)

        # This is the place where all the nice calendars are stored.
        @paths=Array( "/usr/share/calendar" );

        env_dir=ENV["CALENDAR_DIR"]
        if !env_dir.nil? && File.directory?(env_dir)
          @paths.push(env_dir)
        end

      end 

      # TODO remove this if I get the native libraries working
      def list_files 
        return @paths.collect{ |p| Dir.glob("#{p}/*") }
      end 


    end 

  end

end
