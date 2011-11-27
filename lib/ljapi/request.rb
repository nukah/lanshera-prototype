require 'xmlrpc/client'
require 'digest/md5'
require 'ljapi/user'
require 'date'

module LJAPI
  module Request
    
    def self.time_to_ljtime(time)
          time.strftime '%Y-%m-%d %H:%M:%S'
    end
        
    def self.ljtime_to_time(str)
          dt = DateTime.strptime(str, '%Y-%m-%d %H:%M')
          Time.gm(dt.year, dt.mon, dt.day, dt.hour, dt.min, 0, 0)
    end
    
    class LJException < Exception 
      attr_accessor :message
      def initialize(error)
        @message = error
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
            'auth_response' => response
            })
        end
        @result = {}
      end

      def run
        connection = XMLRPC::Client.new('www.livejournal.com', '/interface/xmlrpc')
        command = 'LJ.XMLRPC'.concat('.').concat(@call)
        ok, res = connection.call2(command, @request)
        raise LJException.new(res) if !ok
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