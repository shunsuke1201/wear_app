class UsersController < ApplicationController
  before_action :user_find, { only:[:show, :edit, :update, :destroy, :followings, :followers]}
  before_action :authenticate_user!, except: [:index]
  
  def index
    if user_signed_in?
      unsorted_users = User.where.not(id: current_user.id)
      @users = unsorted_users.sort_by { |user| -current_user.genre_match_percentage(user) }
    else
      @users = User.all
    end
  end

  def show
    @following_posts = Post.joins(:user).where(user_id: @user.followings.ids).order('created_at DESC')
    @favorite_posts = Post.joins(:favorites).where(favorites: { user_id: @user.id })
    @genres = @user.genres
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
    if @user == current_user
      @user.destroy
      redirect_to root_path, notice: "アカウントを削除しました"
    else
      redirect_to users_path, alert: "不正なアクセスです"
    end
  end
  
  def followings
    @users = @user.followings
  end
  
  def followers
    @users = @user.followers
  end
  
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "ゲストユーザーとしてログインしました。"
  end
  
  private
  
  def user_find
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :height, :weight, :profile_image, :password, :password_confirmation, :current_password, genre_ids: [])
  end
end
