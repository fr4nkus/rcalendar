#!/usr/bin/env ruby 

# To be used as a mixin
module CalendarPath

    # calendar uses a list of paths in descending order of desireability.
    def CalendarPath.Preferred(dir=nil)

      return [
        dir,
        ENV["PWD"],
        ENV["CALENDAR_DIR"],
        "#{ENV["HOME"]}/.calendar",
      ].reject! { |p| p.nil? }

    end


end
