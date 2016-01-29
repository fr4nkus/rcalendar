require 'ronin/calendar/base_cli' # TODO move this somewhere neater.
require 'google/apis/calendar_v3'

module Ronin

  class Calendar < BaseCli

    Calendar = Google::Apis::CalendarV3

    desc 'list', 'List upcoming events'
    method_option :limit, type: :numeric

    def list()

      calendar = Calendar::CalendarService.new
      calendar.authorization = user_credentials_for(Calendar::AUTH_CALENDAR)

      page_token = nil
      limit = options[:limit] || 1000

      begin

        result = calendar.list_events('primary',
            max_results:   [limit, 100].min,
            single_events: true, # TODO what happens when false?
            order_by:     'startTime',
            time_min:     Time.now.iso8601
            page_token:   page_token,
            fields:       'items(id,summary,start),next_page_token'
        )

        result.items.each do |event|
          time = event.start.date_time || event.start.date
          say "#{time}, #{event.summary}"
        end

        limit -= result.items.length

        if result.next_page_token
          page_token = result.next_page_token
        else
          page_token = nil
        end

      end while !page_token.nil? && limit > 0

    end

  end # class

end # module
