class FavoritesController < ApplicationController
  before_action :set_post, only: [:create, :destroy]
  
  def index
    @favorites = current_user.favorites.includes(:post)
  end
  
  def create
    @favorite = Favorite.create(user_id: current_user.id, post_id: params[:post_id])
  end
  
  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, post_id: params[:post_id])
    favorite.destroy
  end
  
  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
