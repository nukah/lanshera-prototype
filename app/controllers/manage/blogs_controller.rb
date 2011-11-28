class Manage::BlogsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @accounts = current_user.services
  end

  def import
    account = Service.find(params[:account])
    user = LJAPI::User.new(account.login, account.password)
    begin
      @posts = LJAPI::Request::GetPosts.new(user).run
    rescue LJAPI::Request::LJException => e
      flash[:error] = t('ljapi.error.%s' % e.code)
      redirect_to manage_blog_path
    end
  end
  
  def show
    
  end
end