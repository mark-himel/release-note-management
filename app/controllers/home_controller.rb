class HomeController < ApplicationController
  skip_before_action :require_login
  skip_authorization_check

  def index
    if signed_in?
      path = dashboard_path
    else
      path = sign_in_path
    end
    redirect_to path
  end
end
