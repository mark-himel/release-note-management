class UserMailer < ApplicationMailer
  def sign_up_confirmation(user)
    @user = user
    mail(to: @user.email,
         subject: t('users.mailer.subject.mail_subject'))
  end
end
