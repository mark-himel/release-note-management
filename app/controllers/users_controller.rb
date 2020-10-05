class UsersController < Clearance::UsersController
  load_and_authorize_resource except: %i(new create)

  def new
    @user = User.new
  end

  def create
    response = CreateUser.call(user_params)
    if response[:success]
      redirect_to root_path, notice: t('users.created', user_name: response[:user].name)
    else
      flash.now[:error] = response[:user].errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def user_params
    user_params = params.require(:user).permit(:name,
                                               :email,
                                               :password)
    user_params.delete(:password) unless user_params[:password].present?
    user_params
  end
end
