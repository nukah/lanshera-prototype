class Manage::AccountsController < ApplicationController
  layout 'account'
  before_filter :authenticate_user!
  
  def new
    @service = Service.new
  end

  def create
    @service = Service.new(params[:service])
    if @service.save
      current_user.services << @service
      redirect_to manage_accounts_path
    else
      render :new
    end
  end
  
  def index
    @services = current_user.services
  end
  
  def destroy
    Service.delete(params[:id])
    redirect_to manage_accounts_path
  end
  
  def edit
    @service = Service.find(params[:id])
  end
  
  def update
    @service = Service.find(params[:id])
    
    if @service.update_attributes(:login => params[:login], :password => params[:password])
      redirect_to manage_accounts_path
    else
      render :edit
    end
  end
end
