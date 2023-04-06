class UsersController < ApplicationController
  before_action :user_find, { only:[:show, :edit, :update, :followings, :followers]}
  before_action :authenticate_user!, except: [:index]
  
  def index
    @users = User.all
  end

  def show
  end

  def edit
    if @user != current_user
      redirect_to users_path, alert: "不正なアクセスです"
    end
  end
  
  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank? # パスワードが空の場合
      if @user.update(user_params.except(:password, :password_confirmation, :current_password)) # パスワード以外の情報を更新
        redirect_to user_path(@user), notice: "更新しました"
      else
        render "edit"
      end
    else
      if @user.valid_password?(params[:user][:current_password]) # 現在のパスワードが正しい場合
        if @user.update(user_params.except(:current_password)) # パスワードを含めてユーザー情報を更新
          bypass_sign_in(@user)
          redirect_to user_path(@user), notice: "更新しました"
        else
          flash[:alert] = @user.errors.full_messages.join(', ')
          render "edit"
        end
      else
        flash[:alert] = "現在のパスワードが正しくありません"
        render "edit"
      end
    end
  end





  
  def destroy
  end
  
  def followings
    @users = @user.followings
  end
  
  def followers
    @users = @user.followers
  end
  
  private
  
  def user_find
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :height, :weight, :profile_image, :password, :password_confirmation, :current_password)
  end
end
