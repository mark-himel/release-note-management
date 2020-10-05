class EmailConfirmationsController < ApplicationController
  skip_before_action :require_login, only: :confirm
  before_action :find_user

  def confirm
    if ConfirmEmailAddress.call(@user)
      flash[:notice] = I18n.t('flashes.confirmed_email')
    else
      flash[:error] = I18n.t('flashes.confirm_your_email')
    end
    redirect_to sign_in_path
  end

  private

  def find_user
    token = params[:token] || params[:user][:token]
    @user = User.find_by!(email_confirmation_token: token)
  end
end
