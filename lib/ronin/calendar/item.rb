module Ronin

  class Calendar

    require 'date'


    class Item

      attr_reader :comment

      def self.Parse( line ) 

        calItemObj=nil
     
        case line
        when /^[0-9\/]+\t/
          calItemObj= Entry.new(line)
        else
          calItemObj= Comment.new(line)
        end

        return calItemObj
      end


      def to_s
        return @raw.chomp
      end


    end


    class Entry < Item


      @@today = Date.today

      attr_reader :date

      def initialize(raw)

        #$log.debug( "Initializing" )

        @raw=raw
        # Only lines with a tab seperator are valid (from man calendar!)    
        ( @date_str, @comment ) = raw.split(/\t+/)
        @date=Entry.Parse( @date_str )

      end


      def self.Parse(date_str)

        dateObj=nil
      
        #$log.debug( "Parsing date #{date_str}" )

        # TODO Add variations here. ie. Easter -1 (this is why the native libraries would help)
        case date_str
        when /^\d+\/\d+$/ # eg 02/20

          dateObj = Date.strptime("#{date_str}/#{@@today.year}", '%m/%d/%Y')

        else

          puts "Failed to interpret '#{date_str}' defaulting to today"
          dateObj = @@today
        end

        # We want the next occurence of a date.
        if @@today.jd > dateObj.jd
          dateObj = dateObj >> 12 # get the date object next year.
        end

        return dateObj
      end


      def to_s
        return "#{@raw.chomp} : #{@date}"
      end


    end


    class Comment < Item


      def initialize(line)
        #$log.debug( "Initializing Calendar::Comment" )
        @comment=line
        @raw=line
      end


    end

  end 

end
