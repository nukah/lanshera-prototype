require 'ljapi/request'
require 'cgi'
require 'sanitize'

module LJAPI
  module Request
    class EditPost < Req
      def initialize(user, id, options)
        super('editevent', user)
        @id = id
        @request.update(options) if options
      end
      
      def run
        super
        @result
      end
    end
    
    class GetPosts < Req
      def initialize(user, options = nil)
        super('getevents', user)
        @request['lineendings'] = 'unix'
        @request['noprops'] = 'true'
        @request['notags'] = 'true'
        if options and options['since']
          @request['selecttype'] = 'syncitems'
          @request['lastsync'] = LJAPI::Request::time_to_ljtime(options['since'])
        else
          @request['selecttype'] = 'lastn'
          @request['howmany'] = '50'
        end
      end
      
      def run
        super
        @posts = []
        @result['events'].each { |item|
          probe = {}
          probe['id'] = item['itemid']
          probe['subject'] = item['subject'].force_encoding('utf-8').encode if item['subject']
          probe['body'] = Sanitize.clean(item['event'].force_encoding('utf-8').encode)
          probe['time'] = LJAPI::Request::ljtime_to_time(item['logtime'])
          probe['url'] = item['url']
          probe['sec'] = item['security'].force_encoding('utf-8').encode if item['security']
          probe['anum'] = item['anum']
          @posts << probe
        }
        @posts
      end
    end
  end
end