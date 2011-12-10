class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, :with => :render_404
  
  protect_from_forgery
  private
  def render_404(exception = nil)
    render :template => 'errors/404', :status => 404
  end
end
