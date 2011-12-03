class Manage::AccountsController < ApplicationController
  layout 'account'
  before_filter :authenticate_user!
  
  def new
    @service = Service.new
  end

  def create
    puts params[:service][:login]
    flash[:notice] = t('account_exists') and redirect_to manage_accounts_path and return if current_user.services.exists?(:login => params[:service][:login])
    @service = Service.find_or_create_by_login(params[:service])
    if @service.save
      current_user.services << @service
      redirect_to manage_accounts_path and return
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
