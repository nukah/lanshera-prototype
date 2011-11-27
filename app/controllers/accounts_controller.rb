class AccountsController < ApplicationController
  layout 'account'
  before_filter :authenticate_user!
  
  def new
  end

  def create
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

end
