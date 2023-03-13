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
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "更新しました"
    else
      render "edit"
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
    params.require(:user).permit(:username, :height, :weight, :profile, :profile_image)
  end
end
