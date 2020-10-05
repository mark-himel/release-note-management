class ConfirmEmailAddress
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def self.call(user)
    new(user).call
  end

  def call
    user.update(email_confirmed_at: Time.current, email_confirmation_token: nil) ? true : false
  end
end
