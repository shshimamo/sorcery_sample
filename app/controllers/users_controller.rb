class UsersController < ApplicationController
  before_action :require_login_from_http_basic, only: [:login_from_http_basic]
  skip_before_action :require_login, only: [:index, :new, :create, :activate, :login_from_http_basic]

  # GET /users
  # GET /users.xml
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.activation_needed_email(@user).deliver_now
      redirect_to(:users, notice: 'Registration successfull. Check your email for activation instructions.')
    else
      render action: 'new'
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to(@user, notice: 'User was successfully updated.')
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(users_url)
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to(login_path, notice: 'User was successfully activated.')
    else
      not_authenticated
    end
  end

  # The before action requires authentication using HTTP Basic,
  # And this action redirects and sets a success notice.
  def login_from_http_basic
    redirect_to users_path, notice: 'Login from basic auth successful'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
