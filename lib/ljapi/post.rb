require 'ljapi/request'
require 'cgi'

module LJAPI
  module Request
    class GetPosts < Req
      def initialize(user, options = nil)
        super('getevents', user)
        @request['lineendings'] = 'unix'
        if options and options['since']
          @request['selecttype'] = 'syncitems'
          @request['lastsync'] = LJAPI::Request::time_to_ljtime(options['since'])
        else
          @request['selecttype'] = 'lastn'
          @request['howmany'] = 50
        end
      end
      
      def run
        super
        @posts = []
        @result['events'].each { |item|
          probe = {}
          probe['id'] = item['itemid']
          probe['subject'] = item['subject'] if item['subject']
          probe['body'] = CGI.escape_html(item['event'])
          probe['time'] = LJAPI::Request::ljtime_to_time(item['logtime'])
          probe['url'] = item['url']
          probe['sec'] = item['security'] if item['security'] 
          probe['anum'] = item['anum']
          @posts << probe
        }
        @posts
      end
    end
  end
end