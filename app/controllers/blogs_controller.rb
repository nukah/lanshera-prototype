class BlogsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @accounts = current_user.services
  end

  def import
    account = Service.find(params[:account])
    user = LJAPI::User.new(account.login, account.password)
    begin
      @posts = LJAPI::Request::GetPosts.new(user).run
    rescue LJAPI::Request::LJException => e
      flash[:error] = e.message
      redirect_to import_account_path
    end
  end

end
