require 'xmlrpc/client'

class TestcommentController < ApplicationController
  before_filter :authenticate_user!
  rescue_from Exception do |exc|
    render 'testcomment/error', :locals => { :error => exc }
  end
  
  def submit
    login = params[:login]
    password = params[:password]
    journal = /\/\/(\w*).*\/(\d*)/.match(params[:link])[1]
    pid = /\/\/(\w*).*\/(\d*)/.match(params[:link])[2]
    subject = ERB::Util.html_escape(params[:subject])
    body = ERB::Util.html_escape(params[:body])
    
    connection = XMLRPC::Client.new('www.livejournal.com', '/interface/xmlrpc')
    
    request = {
      'clientversion' => 'Ruby',
      'ver' => 1,
      'journal' => journal,
      'ditemid' => pid,
      'username' => login,
      'password' => password,
      'subject' => subject,
      'body' => body
    }
    
    response = connection.call('LJ.XMLRPC.addcomment',request)
    
    if response['status'] != 'OK'
      render 'testcomment/error'
    else 
      redirect_to response['commentlink']
    end
  end
end
