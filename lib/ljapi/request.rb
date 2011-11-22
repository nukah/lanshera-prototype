require 'xmlrpc/client'
require 'digest/md5'
require 'ljapi/user'
require 'date'

module LJAPI
  module Request
    def self.time_to_ljtime time
          time.strftime '%Y-%m-%d %H:%M:%S'
    end
        
    def self.ljtime_to_time str
          dt = DateTime.strptime(str, '%Y-%m-%d %H:%M')
          Time.gm(dt.year, dt.mon, dt.day, dt.hour, dt.min, 0, 0)
    end
    
    class Req
      def initialize(call, user = nil)
        @call = call
        @user = user

        @request = {
          'clientversion' => 'Ruby',
          'ver' => 1
        }
        
        @result = {}
        if user
          challenge = Challenge.new.run
          response = Digest::MD5.hexdigest(challenge + Digest::MD5.hexdigest(user.password))
          @request.update({
            'user' => @user.username,
            'auth_method' => 'challenge',
            'auth_challenge' => challenge,
            'auth_response' => response
            })
        end
      end

      def run
        connection = XMLRPC::Client.new('www.livejournal.com', '/interface/xmlrpc')
        command = 'LJ.XMLRPC'.concat('.').concat(@call)
        begin
          @result = connection.call(command, @request)
        rescue EOFError => exc
          @result['errmsg'] = 'Critical error'
        rescue XMLRPC::FaultException => exc
          @result['errmsg'] = exc.message
        end
      end
    end

    class Challenge < Req
      def initialize
        super('getchallenge', nil)
      end

      def run
        super
        return @result['challenge']
      end
    end
  end
end