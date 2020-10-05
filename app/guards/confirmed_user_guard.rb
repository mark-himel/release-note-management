class ConfirmedUserGuard < Clearance::SignInGuard
  def call
    if user_confirmed?
      failure I18n.t('users.mailer.subject.confirm_email')
    else
      next_guard
    end
  end

  def user_confirmed?
    signed_in? && current_user.provider.blank? && current_user.email_confirmed_at.blank?
  end
end
