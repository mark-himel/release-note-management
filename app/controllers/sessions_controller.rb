class SessionsController < ApplicationController
  skip_before_action :require_login, only: :github

  def new
    render 'home/index'
  end

  def create
    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create
      else
        flash.now.notice = t('flashes.failure_after_create')
        render template: 'sessions/new', status: :unauthorized
      end
    end
  end

  def github
    user = CreateUserFromOmniAuth.call(auth_hash)
    if user
      sign_in(user)
      redirect_to dashboard_path
    else
      redirect_to root_path
    end
  end

  def destroy
    current_user.update!(last_seen_at: Time.now)
    sign_out
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
