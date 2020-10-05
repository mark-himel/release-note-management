class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Clearance::Controller
  include Errors::Handler
  before_action :require_login

  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to root_path
  end
end
