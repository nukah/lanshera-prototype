require 'ljapi/request'

module LJAPI
  class User
    attr_accessor :username, :password, :fullname
    
    def initialize(user=nil, password=nil)
      @username = user
      @password = password
    end
    def journal
      @username
    end
    def to_s
      "#{@username}"
    end
  end
end