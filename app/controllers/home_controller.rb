class HomeController < ApplicationController
  def index
    flash[:notice] = "Finally"
  end

end
