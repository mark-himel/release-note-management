class CreateUser
  attr_accessor :user_params

  def initialize(user_params)
    @user_params = user_params
  end

  def self.call(user_params)
    new(user_params).call
  end

  def call
    create_and_notify
  end

  def create_and_notify
    user = User.new(user_params)
    user.email_confirmation_token = Clearance::Token.new
    response = {}
    if user.save
      deliver_email(user)
      response[:success] = true
    else
      response[:success] = false
    end
    response[:user] = user
    response
  end

  def deliver_email(user)
    ::UserMailer.sign_up_confirmation(user).deliver_now
  end
end
