require 'xmlrpc/client'
require 'digest/md5'
require 'ljapi/user'
require 'date'

module LJAPI
  module Request
    MAX_ATTEMPTS = 3
    
    def self.time_to_ljtime(time)
          time.strftime '%Y-%m-%d %H:%M:%S'
    end
        
    def self.ljtime_to_time(str)
          dt = DateTime.strptime(str, '%Y-%m-%d %H:%M')
          Time.gm(dt.year, dt.mon, dt.day, dt.hour, dt.min, 0, 0)
    end
    
    class LJException < Exception 
      attr_accessor :code
      def initialize(error)
        @code = error
      end
    end
    
    class Req
      def initialize(call, user)
        @call = call
        @user = user
        @request = {
          'clientversion' => 'Ruby',
          'ver' => 1
        }
        if user
          challenge = Challenge.new.run
          response = Digest::MD5.hexdigest(challenge + Digest::MD5.hexdigest(user.password))
          @request.update({
            'username' => user.username,
            'auth_method' => 'challenge',
            'auth_challenge' => challenge,
            'auth_response' => response,
            'usejournal' => user.username,
            })
        end
        @result = {}
      end

      def run
        connection = XMLRPC::Client.new('www.livejournal.com', '/interface/xmlrpc')
        connection.timeout = 60
        command = 'LJ.XMLRPC'.concat('.').concat(@call)
        attempts = 0
        begin
          attempts += 1
          ok, res = connection.call2(command, @request)
        rescue EOFError
          retry if(attempts < MAX_ATTEMPTS)
        rescue Timeout::Error
          raise LJException.new(1)
        end
        raise LJException.new(2) if !ok
        @result = res if ok
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